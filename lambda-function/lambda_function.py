import json
import urllib.parse
import boto3

print('Loading function')

s3 = boto3.client('s3', endpoint_url='http://127.0.0.1:4566', region_name='sa-east-1', aws_access_key_id='test', aws_secret_access_key='test')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    new_key = 'temp/' + key 

    try:
        s3.copy_object(Bucket=bucket, CopySource={'Bucket': bucket, 'Key': key}, Key=new_key)

        s3.delete_object(Bucket=bucket, Key=key)

        print(f"Object moved from '{key}' to '{new_key}'")
        return {
            'statusCode': 200,
            'body': json.dumps('Object moved successfully')
        }
    except Exception as e:
        print(e)
        print(f'Error moving object from {key} to /temp in bucket {bucket}. Make sure they exist and your bucket is in the same region as this function.')
        raise e
