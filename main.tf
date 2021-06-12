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

module "fargate" {
  source = "./modules/fargate"
  app_name = "fargate"

}

