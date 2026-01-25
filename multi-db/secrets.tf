# resource "random_password" "db_password" {
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "multi-db-credentials-${random_id.suffix.hex}"
  description = "Database credentials for multi-db project"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = aws_db_instance.postgres.address
    port     = var.db_port
    dbname   = var.db_name
  })
}
