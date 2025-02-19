resource "aws_lambda_function" "create_url" {
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_bucket_object.key
  function_name    = "create_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "create_url.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.8"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.url_data.name
    }
  }
}

resource "aws_lambda_function" "get_url" {
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_bucket_object.key
  function_name    = "get_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "get_url.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.8"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.url_data.name
    }
  }
}

resource "aws_lambda_function" "get_all" {
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_bucket_object.key
  function_name    = "get_all_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "get.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.8"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.url_data.name
    }
  }
}

resource "aws_lambda_function" "update_url" {
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_bucket_object.key
  function_name    = "update_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "update_url.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.8"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.url_data.name
    }
  }
}

resource "aws_lambda_function" "delete_url" {
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_bucket_object.key
  function_name    = "delete_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "delete_url.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.8"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.url_data.name
    }
  }
}