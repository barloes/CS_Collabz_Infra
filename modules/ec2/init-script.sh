Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash 
aws_account=642151248908
port1=6379
port2=80
ECR_name=stage
image1=redis
image2=nginx

sudo su
systemctl start docker
systemctl enable docker
systemctl restart docker
docker system prune -af
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin $aws_account.dkr.ecr.ap-southeast-1.amazonaws.com

docker pull $aws_account.dkr.ecr.ap-southeast-1.amazonaws.com/$ECR_name:$image1
docker run -d -p $port1:$port1 $aws_account.dkr.ecr.ap-southeast-1.amazonaws.com/$ECR_name:$image1

docker pull $aws_account.dkr.ecr.ap-southeast-1.amazonaws.com/$ECR_name:$image2
docker run -d -p $port2:$port2 $aws_account.dkr.ecr.ap-southeast-1.amazonaws.com/$ECR_name:$image2
--//