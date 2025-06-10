resource "aws_lambda_layer_version" "common" {
  filename          = "../layers/layer.zip"
  layer_name        = "energy_common_deps"
  source_code_hash  = filebase64sha256("../layers/layer.zip")
  compatible_runtimes = ["python3.10"]
}
