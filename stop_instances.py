import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(Filters=[{'Name': 'tag:Name', 'Values': ['web_server']}])['Reservations']
    
    for instance in instances:
        instance_id = instance['Instances'][0]['InstanceId']
        ec2.stop_instances(InstanceIds=[instance_id])
        
    return 'Successfully stopped EC2 instances'
