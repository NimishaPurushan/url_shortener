resource "aws_api_gateway_rest_api" "lambda_api" {
  name        = "lambda-api"
  description = "API for Lambda"
}

# Define URL resource
resource "aws_api_gateway_resource" "url_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = "url"
}

# Define URL/{short_url} resource for GET, PUT, DELETE
resource "aws_api_gateway_resource" "short_url_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_resource.url_resource.id
  path_part   = "{short_url}"
}

# CORS (OPTIONS method)
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.short_url_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.short_url_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.short_url_resource.id  # FIXED!
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.short_url_resource.id  # FIXED!
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS, GET, POST'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}

resource "aws_api_gateway_method" "options_method2" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.url_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration2" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.url_resource.id
  http_method = aws_api_gateway_method.options_method2.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_method_response" "options_response2" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.url_resource.id  # FIXED!
  http_method = aws_api_gateway_method.options_method2.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response2" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.url_resource.id  # FIXED!
  http_method = aws_api_gateway_method.options_method2.http_method
  status_code = aws_api_gateway_method_response.options_response2.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS, GET, POST'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}

# POST /url
resource "aws_api_gateway_method" "post_url_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.url_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_url_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_api.id
  resource_id             = aws_api_gateway_resource.url_resource.id
  http_method             = aws_api_gateway_method.post_url_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.create_url.invoke_arn
}

resource "aws_lambda_permission" "apigateway_create_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/*"
}

# resource "aws_api_gateway_method_response" "post_url_response" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   resource_id = aws_api_gateway_resource.url_resource.id
#   http_method = aws_api_gateway_method.post_url_method.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Headers" = true
#   }
# }

# resource "aws_api_gateway_integration_response" "post_url_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.lambda_api.id
#   resource_id = aws_api_gateway_resource.url_resource.id
#   http_method = aws_api_gateway_method.post_url_method.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS, POST, GET'"
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
#   }
# }

# GET /url/{short_url}
resource "aws_api_gateway_method" "get_url_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.short_url_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_url_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_api.id
  resource_id             = aws_api_gateway_resource.short_url_resource.id
  http_method             = aws_api_gateway_method.get_url_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = aws_lambda_function.get_url.invoke_arn
}

resource "aws_lambda_permission" "apigateway_get_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/*"
}


# API Deployment
resource "aws_api_gateway_deployment" "lambda_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  depends_on  = [
    aws_api_gateway_integration.post_url_integration,
    aws_api_gateway_integration.get_url_integration
  ]

  triggers = {
    redeployment = timestamp()
  }
}

resource "aws_api_gateway_stage" "lambda_api_stage" {
  deployment_id = aws_api_gateway_deployment.lambda_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  stage_name    = "dev"
}

output "api_gateway_invoke_url" {
  value = "${aws_api_gateway_stage.lambda_api_stage.invoke_url}"
}
