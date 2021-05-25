locals{

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

module "fargate" {
  source = "./modules/fargate"

  app_name = "junecs"
}


