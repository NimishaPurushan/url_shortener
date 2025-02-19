import boto3
import json
import logging
import random
import string

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('URLData')

def generate_short_code(length=6):
    """Generate a random short code."""
    return ''.join(random.choices(string.ascii_letters.lower() + string.digits, k=length))

def get_unique_short_code():
    """Ensure short code is unique by checking the database."""
    while True:
        short_code = generate_short_code()
        response = table.get_item(Key={'short_url': short_code})
        if 'Item' not in response:  # If short_code doesn't exist, it's unique
            return short_code

def lambda_handler(event, context):
    try:
        # Parse the body to JSON
        body = json.loads(event['body'])
        long_url = body['long_url']
        item = {
            'long_url': long_url,
            'short_url': get_unique_short_code() 
        }
        
        table.put_item(Item=item)
        logger.info("Item added to DynamoDB: %s", item)
        
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item added to DynamoDB', 'item': item}),
            'headers': {
            "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
            "Access-Control-Allow-Headers": "Content-Type"}
        }
    
    except json.JSONDecodeError:
        logger.error("Invalid JSON in request body: %s", event['body'])
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid JSON format', 'received': event['body']}),
            'headers': {
            "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
            "Access-Control-Allow-Headers": "Content-Type"}
        }
    
    except Exception as e:
        logger.error("Error adding item to DynamoDB: %s", str(e))
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e), 'event': event}),
            'headers': {
            "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Methods": "OPTIONS, POST, GET", 
            "Access-Control-Allow-Headers": "Content-Type"}
        }
