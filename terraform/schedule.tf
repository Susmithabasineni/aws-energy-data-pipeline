resource "aws_lambda_function" "data_feeder" {
  function_name = "energy_data_feeder"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "generate_data.lambda_handler"
  runtime       = "python3.10"
  timeout       = 30
  memory_size   = 128

  filename         = "../data_generator/generate_data.zip"
  source_code_hash = filebase64sha256("../data_generator/generate_data.zip")
  layers           = [aws_lambda_layer_version.common.arn]
}

resource "aws_cloudwatch_event_rule" "five_min_schedule" {
  name                = "fiveMinEnergyFeedSchedule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.five_min_schedule.name
  target_id = "energy-data-feeder"
  arn       = aws_lambda_function.data_feeder.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_feeder.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.five_min_schedule.arn
}
