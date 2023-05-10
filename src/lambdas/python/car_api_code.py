import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

def lambda_handler(event, context):
    import json

    body = event['body']

    body = json.loads(body)
    
    tabla_estado = dynamodb.Table('Estado')
    tabla_electrolinera = dynamodb.Table('Electrolinera')

    if ('ID_PuntoCarga' in body): # Si la petición recibida tiene un ID_PuntoCarga, se devuelve el estado de ese punto de carga
        response = tabla_estado.get_item(Key={'ID_Estado': body['ID_PuntoCarga']}, TableName='Estado') #TODO: Contemplar si no existe el ID
        return {
            'statusCode': 200,
            'body': response['Item']
        }
    elif (('lat1' in body) and ('lat2' in body) and ('lon1' in body) and ('lon2' in body)): # Hemos recibido una petición de electrolineras en un área
        # Hacemos una query a la tabla de electrolineras para obtener las electrolineras en el área
        response = tabla_electrolinera.scan(
            FilterExpression='ubic_lat BETWEEN :lat1 AND :lat2 AND ubic_lon BETWEEN :lon1 AND :lon2',
            ExpressionAttributeValues={
                ':lat1': body['lat1'],
                ':lat2': body['lat2'],
                ':lon1': body['lon1'],
                ':lon2': body['lon2']
            }
        )
        return {
            'statusCode': 200,
            'body': response['Items']
        }
    else: # Si no, devolvemos un error
        return {
            'statusCode': 400,
            'body': 'Bad request. No se ha especificado un ID_PuntoCarga o un área de búsqueda (campos lat1, lat2, lon1 y lon2).'
        }

