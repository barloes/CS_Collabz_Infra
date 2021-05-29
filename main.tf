locals{

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

/*
module "ecs_ecr" {
  source = "./modules/ecr"

  app_name = "junecr"
}

*/

module "ecr" {
  source = "./modules/ecr"

  app_name = "imagerepo"
}



module "ec2" {
  source = "./modules/ec2"

  instance_type = "t4g.nano"
  ami_id = "ami-032eefd614c03b622"

}
