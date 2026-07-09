# Terraform Backend Configuration
#
# SETUP INSTRUCTIONS:
# 1. First run: terraform init (without backend)
# 2. Create the S3 bucket and DynamoDB table manually or with Terraform
# 3. Uncomment the backend block below
# 4. Run: terraform init -migrate-state
#
# This will migrate the local state to the S3 backend.
#
# terraform {
#   backend "s3" {
#     bucket         = "YOUR_STATE_BUCKET_NAME"
#     key            = "terraform/state.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
