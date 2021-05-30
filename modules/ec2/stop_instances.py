import boto3

# Boto Connection
ec2 = boto3.resource('ec2', 'ap-southeast-1')

def lambda_handler(event, context):

  # Filter running instances that should stop
  instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])

  # Retrieve instance IDs
  instance_ids = [instance.id for instance in instances]

  # stopping instances
  stopping_instances = ec2.instances.filter(Filters=[{'Name': 'instance-id', 'Values': instance_ids}]).stop()
