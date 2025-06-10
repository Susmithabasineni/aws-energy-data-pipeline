#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"


if [ -f last_outputs.json ]; then
  echo "Cleaning up resources from previous run using outputs file"
  if command -v jq >/dev/null 2>&1; then
    BUCKET=$(jq -r '.s3_bucket_name.value // empty' last_outputs.json)
    TABLE=$(jq -r '.dynamodb_table_name.value // empty' last_outputs.json)
    LAMBDA=$(jq -r '.lambda_function_name.value // empty' last_outputs.json)

    if [ -n "$BUCKET" ]; then
      echo "Deleting S3 bucket $BUCKET"
      aws s3 rb "s3://$BUCKET" --force || echo "Could not delete bucket $BUCKET"
    fi
    if [ -n "$TABLE" ]; then
      echo "Deleting DynamoDB table $TABLE"
      aws dynamodb delete-table --table-name "$TABLE" || echo "Could not delete table $TABLE"
    fi
    if [ -n "$LAMBDA" ]; then
      echo "Deleting Lambda function $LAMBDA"
      aws lambda delete-function --function-name "$LAMBDA" || echo "Could not delete lambda $LAMBDA"
    fi
  else
    echo "jq not installed; skipping cleanup based on outputs"
  fi
  rm -f last_outputs.json
fi

terraform init
# Destroy existing resources using Terraform state if it exists
terraform destroy -auto-approve || true
terraform apply -auto-approve

# Save outputs for next cleanup
terraform output -json > last_outputs.json

terraform init
# Destroy existing resources to avoid naming collisions
terraform destroy -auto-approve || true
terraform apply -auto-approve

