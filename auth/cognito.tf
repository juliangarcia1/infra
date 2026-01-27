resource "aws_cognito_user_pool" "this" {
  name = "${var.project_name}-user-pool-${var.environment}"

  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
  
  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = "${var.project_name}-${var.environment}-${random_id.suffix.hex}"
  user_pool_id = aws_cognito_user_pool.this.id
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes              = "email profile openid"
    client_id                     = var.google_client_id
    client_secret                 = var.google_client_secret
    attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
    authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
    oidc_issuer                   = "https://accounts.google.com"
    token_request_method          = "POST"
    token_url                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
    name     = "name"
    picture  = "picture"
  }
}

resource "aws_cognito_user_pool_client" "this" {
  name = "${var.project_name}-client-${var.environment}"

  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = true
  
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  
  supported_identity_providers = ["COGNITO", "Google"]
  
  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  depends_on = [aws_cognito_identity_provider.google]
}
