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
sudo su
systemctl start docker
systemctl enable docker
systemctl restart docker
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 642151248908.dkr.ecr.ap-southeast-1.amazonaws.com
docker pull 642151248908.dkr.ecr.ap-southeast-1.amazonaws.com/imagerepo:latest
docker run -p 80:80 642151248908.dkr.ecr.ap-southeast-1.amazonaws.com/imagerepo:latest
--//