import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('URLData')

def lambda_handler(event, context):    
    try:
        path_params = event.get('pathParameters', {})
        short_code = path_params.get('short_url')
        response = table.delete_item(Key={'short_url': short_code})
        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e), 'event': event})
        }
