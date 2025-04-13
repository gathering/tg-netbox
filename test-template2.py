import os
import requests
import uuid
import argparse
import re
from time import sleep
import json
NETBOX_TOKEN = os.getenv("NETBOX_API_TOKEN")
NETBOX_URL = os.getenv("NETBOX_SERVER_URL")

url_config = NETBOX_URL + '/api/extras/config-templates/'
url_context = NETBOX_URL + '/api/extras/config-contexts/'

def nbpost(query):
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Token " + NETBOX_TOKEN
    }
    response = requests.post(url_config, headers=headers, json=query)
    return response.json()

def nbrender(query, id):
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Token " + NETBOX_TOKEN
    }
    response = requests.post(url_config + f"{str(id)}/render/", headers=headers, json=query)
    return response.json()


def nbdelete(query):
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Token " + NETBOX_TOKEN
    }
    response = requests.delete(url_config + str(query), headers=headers)
    return response


def nbgetcontexct(query):
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Token " + NETBOX_TOKEN
    }
    response = requests.get(url_context + str(query), headers=headers)
    return response

def inline_includes(template_content, template_dir="templates"):
    """
    Recursively inlines {% include "somefile" %} statements by replacing them
    with the file's contents.
    """
    pattern = r"{%\s*include\s+['\"]([^'\"]+)['\"]\s*%}"
    
    while True:
        match = re.search(pattern, template_content)
        if not match:
            break

        include_file = match.group(1)
        include_path = os.path.join(template_dir, include_file)
        
        if not os.path.exists(include_path):
            raise FileNotFoundError(f"Included file '{include_file}' not found in {template_dir}.")
        
        # Read included file
        with open(include_path, 'r') as inc:
            included_text = inc.read()
        
        # Recursively process includes in the newly inlined text
        included_text = inline_includes(included_text, template_dir)
        
        # Replace the entire {% include ... %} line with the included text
        start, end = match.span()
        template_content = template_content[:start] + included_text + template_content[end:]
    
    return template_content


def main():

    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('device_name', type=str, help='Name of the device')
    parser.add_argument('template_name', type=str, help='Name of the template file found in ../templates')

    args = parser.parse_args()
    device_name = args.device_name
    template_file_path = os.path.join('templates', args.template_name)

    context = json.loads(nbgetcontexct("1").content)['data']

    if not os.path.exists(template_file_path):
        print(f"The file {template_file_path} does not exist.")
        return

    with open(template_file_path, 'r') as f:
        template = f.read()

    # Inline any {% include ... %} statements
    template = inline_includes(template, template_dir='.')

    # Add the requested lines at the start of the template
    prelude = """\
{% if test is defined %}
    {% set device = dcim.Device.objects.get(name=device) %}
{% endif %}

"""
    template = prelude + template

    # Create temporary config template in NetBox
    dataz = [{
        'name': str(uuid.uuid4()),
        'environment_params': {
            "extensions": ["jinja2.ext.do"],
            "trim_blocks": True,
            "lstrip_blocks": True
        },
        'template_code': template
    }]
    template_id = nbpost(dataz)[0]['id']

    # Render
    render_payload = {
        "device": device_name,
        "test": True,
    }
    render_payload.update(context)
    result = nbrender(render_payload, template_id)

    # Print out the rendered content
    if "content" in result:
        print(result['content'])
    else:
        print(f'No content. Possible error: {result}')

    # Delete the temporary template from NetBox
    nbdelete(template_id)

if __name__ == '__main__':
    main()
