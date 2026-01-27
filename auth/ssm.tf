resource "aws_ssm_parameter" "user_pool_id" {
  name  = "/${var.project_name}/${var.environment}/cognito/user_pool_id"
  type  = "String"
  value = aws_cognito_user_pool.this.id
}

resource "aws_ssm_parameter" "user_pool_client_id" {
  name  = "/${var.project_name}/${var.environment}/cognito/client_id"
  type  = "String"
  value = aws_cognito_user_pool_client.this.id
}

resource "aws_ssm_parameter" "user_pool_client_secret" {
  name  = "/${var.project_name}/${var.environment}/cognito/client_secret"
  type  = "SecureString"
  value = aws_cognito_user_pool_client.this.client_secret
}

resource "aws_ssm_parameter" "user_pool_domain" {
  name  = "/${var.project_name}/${var.environment}/cognito/domain"
  type  = "String"
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.region}.amazoncognito.com"
}
