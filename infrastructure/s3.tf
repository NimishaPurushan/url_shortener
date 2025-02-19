data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "../backend/src"
  output_path = "../build/dist.zip"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lambda-bucket" 
}

resource "aws_s3_object" "lambda_bucket_object" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "dist.zip"
  source = data.archive_file.lambda.output_path
  etag   = filemd5(data.archive_file.lambda.output_path)
}