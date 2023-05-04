def lambda_handler(event, context):
    import json

    body = event['body']

    body = json.loads(body)

    message = 'Hello {} !'.format(body['key1'])

    return {
        'message' : message
    }
