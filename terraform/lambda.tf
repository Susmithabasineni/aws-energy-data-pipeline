data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../data_generator"
  output_path = "${path.module}/../data_generator.zip"
}

resource "aws_lambda_function" "data_generator" {
  function_name = "data-generator-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "generate_data.lambda_handler"
  runtime       = "python3.9"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.energy_table.name
    }
  }

  timeout = 30
}
  

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.generate_data
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.energy_data.arn
}
