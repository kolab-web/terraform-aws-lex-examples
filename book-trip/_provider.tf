variable "aws_region" {
  default = "eu-west-2"
}

# variable "aws_profile" {
# }

provider "aws" {
  region  = var.aws_region
  
}
