import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('URLData')

def lambda_handler(event, context):    
    try:
        path_params = event.get('pathParameters', {})
        short_code = path_params.get('short_url')

        if not short_code:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing short_url parameter'}),
                'headers': {
            "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
            "Access-Control-Allow-Headers": "Content-Type"}
            }
        response = table.get_item(Key={'short_url': short_code})
        if 'Item' not in response:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Short code not found', 'short_code': short_code}),
                'headers': {
                    "Access-Control-Allow-Origin": "*", 
                    "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
                    "Access-Control-Allow-Headers": "Content-Type"}
            }
        return {
            'statusCode': 302,  # 302 for temporary redirect, 301 for permanent
            #'Location': response['Item']['long_url'],
            'headers': {
                "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
            "Access-Control-Allow-Headers": "Content-Type"
            },
            "body": json.dumps({'message': 'Redirecting to long URL', 'short_url': short_code, 'long_url': response['Item']['long_url']})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e), 'event': event}),
            'headers': {
            "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
            "Access-Control-Allow-Headers": "Content-Type"}
        }
