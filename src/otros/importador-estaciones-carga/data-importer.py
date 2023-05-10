#Para importar la información a DynamoDB

#Importacion de las electrolineras
import pandas as pd
import numpy as np
import boto3
from decimal import Decimal
import json

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
electrolineras_tabla = dynamodb.Table('Electrolinera')

#Eliminamos las entradas anteriores
response = electrolineras_tabla.scan()
for i in response['Items']:
    electrolineras_tabla.delete_item(
        Key={
            'ID_Electrolinera': i['ID_Electrolinera']
        }
    )

def import_electrolinera(row):
    item = {
            'ID_Electrolinera': row["index"],
            'nombre': row['Station Name'],
            'latitud': row['Latitude'],
            'longitud': row['Longitude'],
            'estaciones': row['EV Level2 EVSE Num'],
            'observaciones': "",
            'estado': 1
        }

    electrolineras_tabla.put_item(
        Item = json.loads(json.dumps(item), parse_float=Decimal)
    )

df = pd.read_csv('eeuu_fuel_stations_processed.csv', low_memory=False)
df_mini = df.head(30)
df_mini.apply(import_electrolinera, axis=1)

#Ahora generamos un punto de carga por cada electrolinera importada
df_mini["puntos_de_carga"] = df_mini["EV Level2 EVSE Num"].apply(lambda x: [i for i in range(1, int(x)+1)])
df_mini = df_mini.explode("puntos_de_carga")

#Importacion de los puntos de carga
puntos_de_carga_tabla = dynamodb.Table('PuntoCarga')

#Eliminamos las entradas anteriores
response = puntos_de_carga_tabla.scan()
for i in response['Items']:
    puntos_de_carga_tabla.delete_item(
        Key={
            'ID_PuntoCarga': i['ID_PuntoCarga']
        }
    )

def import_punto_de_carga(row):
        item = {
                'ID_PuntoCarga': row["index"]*1000 + row["puntos_de_carga"],
                'ID_Electrolinera': row["index"],
                'num_pc_electrolinera': row['puntos_de_carga'],
                'estado': 1,
                'uptime': 0
            }
    
        puntos_de_carga_tabla.put_item(
            Item = json.loads(json.dumps(item), parse_float=Decimal)
        )

df_mini.apply(import_punto_de_carga, axis=1)