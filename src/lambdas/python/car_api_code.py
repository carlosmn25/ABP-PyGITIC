import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

def lambda_handler(event, context):
    import json

    body = event['body']

    body = json.loads(body)
    
    tabla_estado = dynamodb.Table('Estado')

    if (body['ID_PuntoCarga']): # Si la petición recibida tiene un ID_PuntoCarga, se devuelve el estado de ese punto de carga
        response = tabla_estado.get_item(Key={'ID_Estado': body['ID_PuntoCarga']}, TableName='Estado')

    """if (body['ID_PuntoCarga']): # Si la petición recibida tiene un ID_PuntoCarga, se devuelve el estado de ese punto de carga
        response = tabla_estado.query(KeyConditionExpression=Key('ID_Estado').eq(body['ID_PuntoCarga'])
        #TableName='Estado',
        #Key={
        #    'ID_Estado': body['ID_PuntoCarga']
        #}
    )
    """

    return {
        'statusCode': 200,
        'body': response['Item']
    }
