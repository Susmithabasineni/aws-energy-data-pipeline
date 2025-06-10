import boto3
import pandas as pd
import plotly.express as px
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.getenv('TABLE_NAME', 'EnergyData')
table = dynamodb.Table(table_name)


def fetch_data():
    return table.scan()['Items']


data = pd.DataFrame(fetch_data())
data['timestamp'] = pd.to_datetime(data['timestamp'])

fig = px.line(data, x='timestamp', y='net_energy_kwh', color='site_id')
fig.show()

fig2 = px.histogram(data[data['anomaly'] == 0], x='site_id')
fig2.show()
