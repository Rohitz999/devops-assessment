# Uncomment for remote state in AWS.
# Replace the bucket and DynamoDB table names with your own.

# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "dev/terraform.tfstate"
#     region          = "us-east-1"
#     encrypt         = true
#     dynamodb_table  = "terraform-locks"
#   }
# }

terraform {
  required_version = ">= 1.6.0"
}