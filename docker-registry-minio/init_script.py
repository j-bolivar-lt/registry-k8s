#!/usr/bin/env python3

import requests
import base64
import json
from kubernetes import client, config


MINIO_ENDPOINT = 'http://116.203.63.120:9000'
MINIO_ADMIN_ACCESS_KEY = 'admin'
MINIO_ADMIN_SECRET_KEY = 'root'
NEW_USER_NAME = 'docker'

import pdb
pdb.set_trace()


headers = {
    'Authorization': f'Bearer {MINIO_ADMIN_ACCESS_KEY}:{MINIO_ADMIN_SECRET_KEY}'
}

response = requests.put(f'{MINIO_ENDPOINT}/v3/add-user', headers=headers, data={'accessKey': NEW_USER_NAME})
response_data = response.json()

if response.status_code != 200:
    print(f"Failed to create user in MinIO: {response_data.get('message', 'Unknown error')}")
    exit(1)

new_access_key = response_data['accessKey']
new_secret_key = response_data['secretKey']


#config.load_kube_config()  # or
config.load_incluster_config()
v1 = client.CoreV1Api()

secret_name = 'minio-user-secret'
namespace = 'minio'  # change to your namespace

secret_data = {
    'accessKey': base64.b64encode(new_access_key.encode()).decode(),
    'secretKey': base64.b64encode(new_secret_key.encode()).decode()
}

secret = client.V1Secret(
    api_version="v1",
    kind="Secret",
    metadata=client.V1ObjectMeta(name=secret_name),
    type="Opaque",
    data=secret_data
)

try:
    v1.create_namespaced_secret(namespace=namespace, body=secret)
    print(f"Secret {secret_name} created in namespace {namespace}")
except client.exceptions.ApiException as e:
    if e.status == 409:  # Conflict, secret already exists
        v1.patch_namespaced_secret(name=secret_name, namespace=namespace, body=secret)
        print(f"Secret {secret_name} updated in namespace {namespace}")
    else:
        print(f"Failed to create/update secret: {e.reason}")
        exit(1)
