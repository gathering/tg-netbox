#!/usr/bin/env python3

import os
import sys
import requests
import uuid
import argparse
import re
import json
from time import sleep
from pathlib import Path

# ---------------------------------------------------------------------
# Environment Variables and Constants
# ---------------------------------------------------------------------
NETBOX_TOKEN = os.getenv("NETBOX_API_TOKEN")
NETBOX_URL = os.getenv("NETBOX_SERVER_URL")

# Validate environment variables
if not NETBOX_TOKEN or not NETBOX_URL:
    print("Error: NETBOX_API_TOKEN or NETBOX_SERVER_URL environment variables not set.")
    sys.exit(1)

URL_CONFIG = f"{NETBOX_URL}/api/extras/config-templates/"
URL_CONTEXT = f"{NETBOX_URL}/api/extras/config-contexts/"

# ---------------------------------------------------------------------
# NetBox Request Helper
# ---------------------------------------------------------------------
def nb_request(method, url, json_data=None, params=None):
    """
    A helper to handle HTTP requests to NetBox, raising errors as needed.
    """
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': f"Token {NETBOX_TOKEN}"
    }
    response = requests.request(method, url, headers=headers, json=json_data, params=params)
    
    # Raise an HTTPError if the request failed (4xx or 5xx).
    response.raise_for_status()
    
    # Attempt to parse JSON response; fall back to text if not JSON.
    if response.content:
        try:
            return response.json()
        except ValueError:
            return response.text
    return None

# ---------------------------------------------------------------------
# NetBox Operations
# ---------------------------------------------------------------------
def create_config_template(template_code):
    """
    Create a new config template in NetBox with the given Jinja2 code.
    Returns the JSON response from NetBox.
    """
    payload = [{
        'name': str(uuid.uuid4()),
        'environment_params': {
            "extensions": ["jinja2.ext.do"],
            "trim_blocks": True,
            "lstrip_blocks": True
        },
        'template_code': template_code
    }]
    return nb_request("POST", URL_CONFIG, json_data=payload)


def render_config_template(template_id, render_payload):
    """
    Renders the given config template (by ID) using the render_payload.
    Returns the JSON response from NetBox.
    """
    endpoint = f"{URL_CONFIG}{template_id}/render/"
    return nb_request("POST", endpoint, json_data=render_payload)


def delete_config_template(template_id):
    """
    Deletes the given config template from NetBox.
    """
    endpoint = f"{URL_CONFIG}{template_id}"
    nb_request("DELETE", endpoint)


def get_config_context(context_id=1):
    """
    Fetches config context data from NetBox by ID.
    Returns the JSON response.
    """
    endpoint = f"{URL_CONTEXT}{context_id}/"
    return nb_request("GET", endpoint)



# ---------------------------------------------------------------------
# Template Inclusion
# ---------------------------------------------------------------------
def inline_includes(template_content, template_dir=".", visited=None):
    """
    Recursively inlines {% include "somefile" %} statements by replacing them
    with the file's contents. Detects cyclical includes to avoid infinite recursion.
    """
    if visited is None:
        visited = set()

    pattern = r"{%\s*include\s+['\"]([^'\"]+)['\"]\s*%}"

    while True:
        match = re.search(pattern, template_content)
        if not match:
            break

        include_file = match.group(1)
        if include_file in visited:
            raise ValueError(f"Detected cyclical include for file: {include_file}")

        visited.add(include_file)
        include_path = os.path.join(template_dir, include_file)

        if not os.path.exists(include_path):
            raise FileNotFoundError(f"Included file '{include_file}' not found in {template_dir}.")

        # Read included file
        with open(include_path, 'r') as inc:
            included_text = inc.read()

        # Recursively process any nested includes
        included_text = inline_includes(included_text, template_dir, visited=visited)

        # Once processed, remove from visited set
        visited.remove(include_file)

        # Replace the entire {% include ... %} line with the included text
        start, end = match.span()
        template_content = template_content[:start] + included_text + template_content[end:]

    return template_content


# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(
        description="Render a NetBox Jinja2 config template for a given device and context."
    )
    parser.add_argument('device_name', type=str, help='Name of the device in NetBox')
    parser.add_argument('template_name', type=str, help='Name of the Jinja2 template file (e.g., "router.j2")')
    args = parser.parse_args()

    device_name = args.device_name
    template_name = args.template_name

    # Determine the full path to the template file.
    script_dir = Path(__file__).parent.resolve()
    template_file_path = script_dir / "templates" / template_name

    # Fetch config context from NetBox (ID=1 in this example)
    context_json = get_config_context(1)
    # The NetBox context often has 'data' as a top-level key,
    # but confirm your NetBox version/response shape.
    context_data = context_json.get('data', {})
    if not context_data:
        print(f"Warning: No 'data' key found in config context ID=1. Using empty context.")
        context_data = {}

    if not template_file_path.exists():
        print(f"The file {template_file_path} does not exist.")
        sys.exit(1)

    # Read the template file
    with open(template_file_path, 'r') as f:
        template = f.read()

    # Inline any {% include ... %} statements
    # We use the directory containing the template itself for includes.
    template = inline_includes(template)

    # Add the requested lines at the start of the template
    # Example: referencing the device in the Jinja2 environment
    prelude = '{% set device = dcim.Device.objects.get(name=device) %}'
    template = prelude + template

    # Create a temporary config template in NetBox
    template_id = None
    try:
        creation_result = create_config_template(template)
        # 'creation_result' should be a list with a single item, if successful
        if not isinstance(creation_result, list) or not creation_result:
            print(f"Unexpected response creating template: {creation_result}")
            sys.exit(1)

        template_id = creation_result[0].get('id')
        if not template_id:
            print(f"Could not retrieve template ID from creation result: {creation_result}")
            sys.exit(1)

        # Prepare the payload for rendering
        render_payload = {
            "device": device_name,
            "test": True,
        }
        # Merge NetBox context data (from config-context) into render payload
        render_payload.update(context_data)

        # Render the template in NetBox
        render_result = render_config_template(template_id, render_payload)

        # Print out the rendered content if it exists
        if "content" in render_result:
            print(render_result['content'])
        else:
            print(f"No content returned. Possible error: {render_result}")

    finally:
        # Always delete the temporary template from NetBox if we created one
        if template_id is not None:
            delete_config_template(template_id)


if __name__ == '__main__':
    main()