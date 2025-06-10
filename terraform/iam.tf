resource "aws_iam_role" "lambda_exec" {
  name = "energy_data_lambda_exec_role-${random_string.iam_suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "energy_data_lambda_logs-${random_string.iam_suffix.result}"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_access" {
  name = "energy_data_access-${random_string.iam_suffix.result}"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:*",
        Resource = aws_dynamodb_table.energy_table.arn
      },
      {
        Effect   = "Allow",
        Action   = "s3:*",
        Resource = [
          aws_s3_bucket.energy_data.arn,
          "${aws_s3_bucket.energy_data.arn}/*"
        ]
      }
    ]
  })
}
