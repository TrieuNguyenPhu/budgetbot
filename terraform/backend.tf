# =============================================================================
# Terraform Backend Configuration - S3 + DynamoDB Locking
# =============================================================================
#
# QUAN TRỌNG: S3 bucket và DynamoDB table phải tồn tại TRƯỚC khi chạy
# `terraform init` với backend này.
#
# Bước 1 - Tạo S3 bucket cho state:
#   aws s3api create-bucket \
#     --bucket budgetbot-tfstate \
#     --region ap-southeast-1 \
#     --create-bucket-configuration LocationConstraint=ap-southeast-1
#
# Bước 2 - Tạo DynamoDB table cho locking:
#   aws dynamodb create-table \
#     --table-name budgetbot-tf-lock \
#     --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --billing-mode PAY_PER_REQUEST \
#     --region ap-southeast-1
#
# Bước 3 - Uncomment block bên dưới và chạy:
#   terraform init -migrate-state
#
# =============================================================================

# terraform {
#   backend "s3" {
#     bucket         = "budgetbot-tfstate"
#     key            = "prod/terraform.tfstate"
#     region         = "ap-southeast-1"
#     dynamodb_table = "budgetbot-tf-lock"
#     encrypt        = true
#   }
# }
