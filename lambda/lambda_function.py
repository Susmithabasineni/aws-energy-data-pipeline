import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.getenv('TABLE_NAME', 'EnergyData')
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        s3 = boto3.client('s3')
        obj = s3.get_object(Bucket=bucket, Key=key)
        data = json.loads(obj['Body'].read())

        for entry in data:
            generated = entry['energy_generated_kwh']
            consumed = entry['energy_consumed_kwh']
            net = generated - consumed
            flag = 0 if net < 0 else 1

            table.put_item(Item={
                'site_id': entry['site_id'],
                'timestamp': entry['timestamp'],
                'energy_generated_kwh': generated,
                'energy_consumed_kwh': consumed,
                'net_energy_kwh': net,
                'anomaly': flag
            })
    return {"status": "Processed"}
