# Total credit given to Valentin2105 for underlying mechanisms: 
# https://gist.github.com/valentin2105/70786b181fa1b972313837325b8c1d14

# Placeholders done by Chris for Ansible.

#!/usr/bin/env python3
import requests
import argparse

# Change this to your domain name or IP address of server running wg-easy
base_url = 'http://localhost:51821'

# Make sure to update the password to the password you set for your webgui
def get_session_id(base_url=base_url):
    path = base_url + '/api/session'
    headers = {'Content-Type': 'application/json'}
    data = '{"password": "{{ blackteam_plaintext_password }}"}'

    # Make initial request to obtain session ID
    response = requests.post(path, headers=headers, data=data)

    # Extract session ID from Set-Cookie header
    session_id = response.cookies.get('connect.sid')
    return session_id

def get_client_data(base_url=base_url, session_id=get_session_id()):
    # Make second request with session ID in Cookie header
    path = base_url + '/api/wireguard/client'
    headers = {'Cookie': f'connect.sid={session_id}'}
    response = requests.get(path, headers=headers)

    # Check if the request was successful and print client data
    if response.status_code == 200:
        client_data = response.json()
        print(f'Number of clients: {len(client_data)}')
        for client in client_data:
            print(f'Client: {client["id"]} {client["name"]} ')
    else:
        print(f'Error: {response.status_code} - {response.text}')

def create_new_client(client_name, base_url=base_url, session_id=get_session_id()):
    # Make third request with session ID in Cookie header and provide a name for the new client to be created
    path = base_url + '/api/wireguard/client'
    headers = {'Content-Type': 'application/json', 'Cookie': f'connect.sid={session_id}'}
    data = '{"name":"'+client_name+'"}'
    response = requests.post(path, headers=headers, data=data)

    # Check if the request was successful and print new client data
    if response.status_code == 200:
        new_client_data = response.json()
        print('New client created:')
        print(f'Client name: {new_client_data["name"]}')
    else:
        print(f'Error: {response.status_code} - {response.text}')

def get_qr(client_id, base_url=base_url, session_id=get_session_id()):
    # Make third request with session ID in Cookie header and provide a name for the new client to be created
    path = base_url + '/api/wireguard/client/' + client_id + '/configuration'
    headers = {'Content-Type': 'application/json', 'Cookie': f'connect.sid={session_id}'}
    response = requests.get(path, headers=headers)

    # Check if the request was successful and print new client data
    if response.status_code == 200:
        print(response.content)
    else:
        print(f'Error: {response.status_code} - {response.text}')

def get_config(client_id, base_url=base_url, session_id=get_session_id()):
    # Make third request with session ID in Cookie header and provide a name for the new client to be created
    path = base_url + '/api/wireguard/client/' + client_id + '/qrcode.svg'
    headers = {'Content-Type': 'application/json', 'Cookie': f'connect.sid={session_id}'}
    response = requests.get(path, headers=headers)

    # Check if the request was successful and print new client data
    if response.status_code == 200:
        print(response.text)
    else:
        print(f'Error: {response.status_code} - {response.text}')


if __name__ == "__main__":
    # Use argparse to accept user arguments
    parser = argparse.ArgumentParser(description='Show Wireguard clients or create a new client')
    parser.add_argument('action', metavar='ACTION', type=str, choices=['status', 'qr', 'config', 'create'], help='Action to perform')
    parser.add_argument('name', metavar='NAME', type=str, nargs='?', help='Name for new client (required for "create" action)')
    args = parser.parse_args()

    if args.action == 'status':
        get_client_data()
    elif args.action == 'qr':
        if not args.name:
            parser.error('ID is required for "qr" action')
        get_qr(args.name)
    elif args.action == 'config':
        if not args.name:
            parser.error('ID is required for "config" action')
        get_qr(args.name)
    elif args.action == 'create':
        if not args.name:
            parser.error('Name is required for "create" action')
        create_new_client(args.name)