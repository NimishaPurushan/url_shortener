# resource "aws_apigatewayv2_api" "lambda_api" {
#   name          = "lambda-api"
#   protocol_type = "HTTP"
#   description   = "API for Lambda"
#   cors_configuration {
#     allow_origins = ["*"]  # Change to ["http://localhost:5173"] if needed
#     allow_methods = ["OPTIONS", "GET", "POST"]
#     allow_headers = ["*"]
#   }
# }

# resource "aws_apigatewayv2_integration" "create_url_integration" {
#   api_id           = aws_apigatewayv2_api.lambda_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.create_url.invoke_arn
# }

# resource "aws_apigatewayv2_integration" "get_url_integration" {
#   api_id           = aws_apigatewayv2_api.lambda_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.get_url.invoke_arn
# }

# resource "aws_apigatewayv2_integration" "get_all_integration" {
#   api_id           = aws_apigatewayv2_api.lambda_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.get_all.invoke_arn
# }

# resource "aws_apigatewayv2_integration" "update_url_integration" {
#   api_id           = aws_apigatewayv2_api.lambda_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.update_url.invoke_arn
# }

# resource "aws_apigatewayv2_integration" "delete_url_integration" {
#   api_id           = aws_apigatewayv2_api.lambda_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.delete_url.invoke_arn
# }

# resource "aws_apigatewayv2_integration" "options_integration" {
#   api_id           = aws_apigatewayv2_api.lambda_api.id
#   integration_type = "MOCK"  
# }

# resource "aws_apigatewayv2_route" "create_url_route" {
#   api_id    = aws_apigatewayv2_api.lambda_api.id
#   route_key = "POST /url"
#   target    = "integrations/${aws_apigatewayv2_integration.create_url_integration.id}"
# }

# resource "aws_apigatewayv2_route" "get_all_route" {
#   api_id    = aws_apigatewayv2_api.lambda_api.id
#   route_key = "GET /urls"
#   target    = "integrations/${aws_apigatewayv2_integration.get_all_integration.id}"
# }

# resource "aws_apigatewayv2_route" "get_url_route" {
#   api_id    = aws_apigatewayv2_api.lambda_api.id
#   route_key = "GET /url/{short_url}"
#   target    = "integrations/${aws_apigatewayv2_integration.get_url_integration.id}"
# }

# resource "aws_apigatewayv2_route" "update_url_route" {
#   api_id    = aws_apigatewayv2_api.lambda_api.id
#   route_key = "PUT /url/{short_url+}"
#   target    = "integrations/${aws_apigatewayv2_integration.update_url_integration.id}"
# }

# resource "aws_apigatewayv2_route" "delete_url_route" {
#   api_id    = aws_apigatewayv2_api.lambda_api.id
#   route_key = "DELETE /url/{short_url+}"
#   target    = "integrations/${aws_apigatewayv2_integration.delete_url_integration.id}"
# }

# resource "aws_apigatewayv2_route" "options_url_route" {
#   api_id    = aws_apigatewayv2_api.lambda_api.id
#   route_key = "OPTIONS /{proxy+}"
#   target    = "integrations/${aws_apigatewayv2_integration.options_integration.id}"
# }

# resource "aws_lambda_permission" "apigateway_create_lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.create_url.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = aws_apigatewayv2_api.lambda_api.execution_arn
# }

# resource "aws_lambda_permission" "apigateway_get_lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.get_url.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = aws_apigatewayv2_api.lambda_api.execution_arn
# }

# resource "aws_lambda_permission" "apigateway_update_lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.update_url.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = aws_apigatewayv2_api.lambda_api.execution_arn
# }

# resource "aws_lambda_permission" "apigateway_delete_lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.delete_url.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = aws_apigatewayv2_api.lambda_api.execution_arn
# }

# resource "aws_lambda_permission" "apigateway_get_all_lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.get_all.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = aws_apigatewayv2_api.lambda_api.execution_arn
# }

# resource "aws_apigatewayv2_stage" "lambda_api_stage" {
#   api_id      = aws_apigatewayv2_api.lambda_api.id
#   name        = "dev"
#   auto_deploy = true

#   default_route_settings {
#     throttling_burst_limit = 5000
#     throttling_rate_limit  = 10000
#   }

#   # access_log_settings {
#   #   destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
#   #   format          = "$context.requestId $context.httpMethod $context.path $context.status"
#   # }

# }

# output "api_gateway_invoke_url" {
#   value = aws_apigatewayv2_stage.lambda_api_stage.invoke_url
# }

# output "localstack_hello_world_url" {
#   value = tomap({
#     "/url" = "${local.localstack_host}/restapis/${aws_apigatewayv2_api.lambda_api.id}/${aws_apigatewayv2_stage.lambda_api_stage.id}/_user_request_/url"
#   })
# }