import os
import requests
import uuid
import argparse
NETBOX_TOKEN = os.getenv("NETBOX_API_TOKEN")
NETBOX_URL = os.getenv("NETBOX_SERVER_URL")

url_config = NETBOX_URL + '/api/extras/config-templates/'





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

def main():

    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('device_name', type=str, help='Name of the device')
    parser.add_argument('template_name', type=str, help='Name of the template file found in ../template')

    args = parser.parse_args()


    global DEVICE_NAME
    DEVICE_NAME = args.device_name
    template_file_path = os.path.join('templates', args.template_name)

    if not os.path.exists(template_file_path):
        print(f"The file {template_file_path} does not exist.")
        return


    with open(template_file_path) as f:
        template = f.read()

    dataz = [{'name': str(uuid.uuid4()),
        'environment_params': {
                "extensions": ["jinja2.ext.do"],
                "trim_blocks": True,
                "lstrip_blocks": True
        },
        'template_code': template}]
    template_id = nbpost(dataz)[0]['id']


    dataz = { "device": DEVICE_NAME, "test": True}

    result = nbrender(dataz, template_id)

    if "content" in result :
        print(result['content'])
    else:
        print(f'No content. Possible error: {result}')

    nbdelete(template_id)




if __name__ == '__main__':
    main()
