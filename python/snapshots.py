# -*- coding: utf-8 -*-

import boto3
import json
import logging
import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec = boto3.client('ec2')

def lambda_handler(event, context):
    logger.info("lambda started with event %s", json.dumps(event))

    volumes=ec.describe_volumes(Filters = [{'Name':'tag:Snapshot', 'Values':['Yes'] }] ).get('Volumes',[])
    for volume in volumes:
        vol_id = volume['VolumeId']

        snap_descr = "%s-%s" % (vol_id, datetime.datetime.utcnow().isoformat())
        snap = ec.create_snapshot( VolumeId=vol_id, Description=snap_descr)
      
        logger.info("Created snapshot for volume %s",vol_id)


if __name__ == "__main__":
    logging.basicConfig()
    lambda_handler({},{})
