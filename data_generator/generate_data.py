# ZIP the generate_data lambda with dependencies
data "archive_file" "generate_data_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../data_generator"
  output_path = "${path.module}/../data_generator.zip"
}

resource "aws_lambda_function" "generate_data" {
  function_name = "generate-data-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "generate_data.lambda_handler"
  runtime       = "python3.9"

  filename         = data.archive_file.generate_data_zip.output_path
  source_code_hash = data.archive_file.generate_data_zip.output_base64sha256

  environment {
    variables = {
      ENERGY_BUCKET_NAME = "your-bucket-name"
    }
  }

  timeout = 30
}

# ZIP the process_data lambda (assumed to have no heavy packages)
data "archive_file" "process_data_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../process_lambda"  # update if different
  output_path = "${path.module}/../process_lambda.zip"
}

resource "aws_lambda_function" "process_data" {
  function_name = "process-data-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "process_data.lambda_handler"
  runtime       = "python3.9"

  filename         = data.archive_file.process_data_zip.output_path
  source_code_hash = data.archive_file.process_data_zip.output_base64sha256

  timeout = 30
}
