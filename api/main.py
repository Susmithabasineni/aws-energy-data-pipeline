from fastapi import FastAPI
import boto3
import os
from boto3.dynamodb.conditions import Key

app = FastAPI()
dynamodb = boto3.resource('dynamodb')
table_name = os.getenv('TABLE_NAME', 'EnergyData')
table = dynamodb.Table(table_name)


@app.get("/site/{site_id}")
def get_site_data(site_id: str, start: str, end: str):
    response = table.query(
        KeyConditionExpression=Key('site_id').eq(site_id)
        & Key('timestamp').between(start, end)
    )
    return response['Items']


@app.get("/site/{site_id}/anomalies")
def get_anomalies(site_id: str):
    response = table.query(KeyConditionExpression=Key('site_id').eq(site_id))
    return [i for i in response['Items'] if i.get('anomaly') == 0]
