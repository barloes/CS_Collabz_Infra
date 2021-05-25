# Terraform Infrastructure
* contain list of terrafirn modules I have created 

# How to use the modules
* On the main.tf in the root directory 

```  
provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}
```
- Configure the profile - aws profile on ~/.aws/credentials 
- Configure the region `eg.ap-southeast-1` 

* Add modules

```
module "anynameyouwant" {
  source = "./modules/fargate"

  app_name = "anynameyouwant"
}
```
- Add the module and configure the source to point to the folder of the module you wish to create `eg.source = "./modules/fargate"`

* Run the Terraform Commands
```
- terraform init
- terraform plan
- terraform apply
```

# Created Modules
1. CF - S3 with cloudfront function
2. ECR and ECS Fargate without LB  

# Special mention
1. [Creating ECS Fargate](https://medium.com/avmconsulting-blog/how-to-deploy-a-dockerised-node-js-application-on-aws-ecs-with-terraform-3e6bceb48785)