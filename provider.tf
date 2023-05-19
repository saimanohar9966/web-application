provider "aws" {
  region  = "ap-southeast-2"
  profile = "sample-website"
}

terraform {
  backend "s3" {
    profile = "sample-website"
    bucket  = "sample-website-123"
    key     = "website-statefile/terraform.tfstate"
    region  = "ap-southeast-2"
  }
}
