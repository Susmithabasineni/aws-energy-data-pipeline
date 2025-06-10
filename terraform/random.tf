resource "random_string" "s3_suffix" {
  length  = 8
  special = false
  upper   = false
}


resource "random_string" "dynamodb_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "iam_suffix" {
  length  = 8
  special = false
  upper   = false
}

