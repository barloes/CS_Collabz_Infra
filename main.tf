locals{

}

provider "aws" {
  profile = "scseAdmin"
  region  = "ap-southeast-1"
}

module "cloudfronts3" {
  source = "./resources/cloudfronts3"

  bucket_name = "cscollabzstaticwebsite"
}

