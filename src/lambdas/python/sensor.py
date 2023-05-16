import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

def lambda_handler(event, context):
    import json

    body = event['body']

    body = json.loads(body)

    table = dynamodb.Table('Estado')
    
    response = table.put_item(
        TableName='Estado',
        Item={
            'ID_Estado': body['ID_Estado'],
            'estado': body['estado'],
            'tiempo': body['tiempo'],
            'matricula': body['matricula'],
            'ID_PuntoCarga': body['ID_PuntoCarga']
        }
    )

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': body,
            'response': response
        })
    }
