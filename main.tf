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
  profile = "personal"
  region  = "ap-southeast-1"

}

module "ecr" {
  source = "./modules/ecr"

  app_name = "stage"
}

module "ec2" {
  source = "./modules/ec2"

  instance_type = "t4g.nano"
  ami_id = "ami-02ccb32cd71d4c9f8"

}

