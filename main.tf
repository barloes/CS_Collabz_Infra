locals{

}

provider "aws" {
  profile = "personal"
  region  = "ap-southeast-1"
}

/*
module "cloudfront" {
  source = "./modules/cloudfronts3"

  bucket_name = "cscollabzstaticwebsite"
  aws_region = "ap-southeast-1"

}
*/

module "ecs_fargate" {
  source = "./modules/fargate"

  app_name = "junecstest"
}


