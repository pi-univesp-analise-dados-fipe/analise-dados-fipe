import datetime
import logging
from azure.storage.blob import BlobServiceClient, BlobClient
import json
import datetime


import azure.functions as func

def main(mytimer: func.TimerRequest) -> None:
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    if mytimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function JK ran at %s', utc_timestamp)
    connection_string = "<sua_connection_string>"
    container = "fipe-data"


def connect_azure_storage(connection_string):
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)


def save_files(container_name, data):
    now = datetime.datetime.now()
    file_name = now.strftime("%Y-%m-%d") + ".json"
    json_data = json.dumps(data)
    blob_client = BlobServiceClient.get_blob_client(container=container_name, blob=file_name)
    blob_client.upload_blob(json_data, overwrite=True)

