provider "aws" {}

module "instance" {
  source        = "./modules/instance"
}


