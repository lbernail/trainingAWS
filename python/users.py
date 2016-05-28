from __future__ import print_function

import boto3
import json

print('Loading function')


def lambda_handler(event, context):
    '''Provide an event that contains the following keys:
      - operation: get
      - tableName
      - key (optional for get)
    '''
    print("Received event: " + json.dumps(event, indent=2))

    operation = event['operation']

    if 'tableName' in event:
        table = boto3.resource('dynamodb').Table(event['tableName'])
    else:
        raise ValueError('No table defined')

    if operation == "get":
        if 'key' in event:
            response = table.get_item( Key={ 'login': event['key'] } )
            item = response['Item']
            return item
        else:
            response = table.scan()
            items = response['Items']
            return items          
        
    else:
        raise ValueError('Unrecognized operation "{}"'.format(operation))
