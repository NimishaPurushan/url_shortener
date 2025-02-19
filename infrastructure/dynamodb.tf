resource "aws_dynamodb_table" "url_data" {
  name           = "URLData"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "short_url"

  attribute {
    name = "short_url"
    type = "S"
  }
}