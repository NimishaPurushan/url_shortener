import boto3
import json
ENDPOINT_URL='http://localhost:4566'


lambda_client = boto3.client('lambda', 
    region_name='us-east-2', 
    endpoint_url=ENDPOINT_URL)


def create():
        result = lambda_client.invoke(
            FunctionName='create_lambda_function',
            InvocationType='RequestResponse',
            Payload=json.dumps( {"body":{"long_url": "https://chatgpt.com/c/67a4118d-7a88-8006-9512-209d97665d40"}})
        )
        assert(result['StatusCode'], 200)
        output = json.loads(result['Payload'].read())
        print(output)
        

def get_lambda():
        result = lambda_client.invoke(
            FunctionName='get_lambda_function',
            InvocationType='RequestResponse'
        )
        assert(result['StatusCode'], 200)
        output = json.loads(result['Payload'].read())
        print(output)

def update_lambda():
        result = lambda_client.invoke(
            FunctionName='update_lambda_function',
            InvocationType='RequestResponse',
            Payload= {"body":{"id": "1", "data": "hello2"}}
        )
        assert(result['StatusCode'], 200)
        output = json.loads(result['Payload'].read())
        print(output)

create()