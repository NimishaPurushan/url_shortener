import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('URLData')

def lambda_handler(event, context):
    try:
        response = table.scan()
        return {

            'statusCode': 200,
            'body': json.dumps(response),
            'headers': {
            "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
            "Access-Control-Allow-Headers": "Content-Type"}
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