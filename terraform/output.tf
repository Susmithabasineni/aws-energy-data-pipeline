output "s3_bucket_name" {
  value = aws_s3_bucket.energy_data.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.energy_table.name
}

output "lambda_function_name" {
  value = aws_lambda_function.processor.function_name
}
