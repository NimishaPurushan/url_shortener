import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('URLData')

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        
        path_params = event.get('pathParameters', {})
        short_url = path_params.get('short_url')
        long_url = body.get('long_url')

        update_expression = "SET #long_url = :long_url"
        expression_attribute_values = {":long_url": long_url}
        expression_attribute_names = {"#long_url": "long_url"} 
        
        response = table.update_item(
            Key={'short_url': short_url},
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values,
            ExpressionAttributeNames=expression_attribute_names,  
            ReturnValues="UPDATED_NEW"
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps(response),
            'headers': {
            "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
            "Access-Control-Allow-Headers": "Content-Type",
        }
        }
    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid JSON format', 'received': event['body']})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e), 'event': event})
        }
