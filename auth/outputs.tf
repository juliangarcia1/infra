output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.this.id
}

output "client_secret" {
  value     = aws_cognito_user_pool_client.this.client_secret
  sensitive = true
}

output "domain_url" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.region}.amazoncognito.com"
}

output "zz_next_steps_google_config_instructions" {
  value = <<EOT

================================================================================
IMPORTANT: FINAL CONFIGURATION STEP REQUIRED
================================================================================

You must now update your Google OAuth Client with the redirect URI generated above.

1. Go to: https://console.cloud.google.com/apis/credentials
2. Select your OAuth 2.0 Client.
3. Under "Authorized redirect URIs", add the following URL:

   https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.region}.amazoncognito.com/oauth2/idpresponse

4. Click Save.

================================================================================
EOT
}
