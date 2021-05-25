# Terraform Infrastructure
* contain list of modules I have copied and look around for personal use.

# How to use the modules
* On the main.tf in the root directory 

```  
provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}
```
1. Configure the profile - aws profile on ~/.aws/credentials 
2. Configure the region `eg.ap-southeast-1` 

* Add modules

```
module "anynameyouwant" {
  source = "./modules/fargate"

  app_name = "anynameyouwant"
}
```
1. Add the module and configure the source to point to the folder of the module you wish to create `eg.source = "./modules/fargate"`

* Run the Terraform Commands
1. terraform init
1. terraform plan
1. terraform apply

# Created Modules
1. CF - S3 with cloudfront function
2. ECR and ECS Fargate without LB  

# Special mention
1. [Creating ECS Fargate](https://medium.com/avmconsulting-blog/how-to-deploy-a-dockerised-node-js-application-on-aws-ecs-with-terraform-3e6bceb48785)