resource "aws_iam_role" "ec2_role" {
  name = "multi-db-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "secrets_policy" {
  name = "multi-db-secrets-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "multi-db-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "multi-db-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "pem_file" {
  content         = tls_private_key.pk.private_key_pem
  filename        = "${path.module}/multi-db-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "app_server" {
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = var.instance_type
  subnet_id            = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name             = aws_key_pair.generated_key.key_name

  tags = {
    Name = "multi-db-ec2-instance"
  }
}

resource "aws_ec2_instance_state" "app_server_state" {
  instance_id = aws_instance.app_server.id
  state       = var.instance_running ? "running" : "stopped"
}

