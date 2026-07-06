#terraform {
#  backend "s3" {
#    bucket         = "your-terraform-state-bucket"
#    key            = "prod/terraform.tfstate"
#    region         = "us-east-1"
#    encrypt        = true
#  }
#}

terraform {
  required_version = ">= 1.6.0"
}