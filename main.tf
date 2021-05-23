locals{

}

provider "aws" {
  profile = "scseAdmin"
  region  = "ap-southeast-1"
}

module "cloudfront" {
  source = "./resources/cloudfronts3"

  bucket_name = "cscollabzstaticwebsite"
  aws_region = "ap-southeast-1"

}

