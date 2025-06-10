resource "aws_dynamodb_table" "energy_table" {
  name         = "${var.dynamodb_table}-${random_string.dynamodb_suffix.result}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "site_id"
  range_key    = "timestamp"

  attribute {
    name = "site_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}
