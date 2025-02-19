variable "rest_api_id" {
  description = "The ID of the REST API"
}

variable "url_resource_id" {
  description = "The ID of the URL resource"
}
# CORS (OPTIONS method)
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.url_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = var.rest_api_id
  resource_id = var.url_resource_id
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
  rest_api_id = var.rest_api_id
  resource_id = var.url_resource_id 
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = var.rest_api_id
  resource_id = var.url_resource_id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS, GET, POST'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}