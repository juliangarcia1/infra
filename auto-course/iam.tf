resource "aws_iam_role" "ec2_role" {
  name = "auto_course_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Note: The secret name lookup needs to match exactly what was created in multi-db
# In data.tf we use a partial match or need to fix the name.
# For now, let's assume we can list secrets to find the right one or use a more broad permission if the name is dynamic.
resource "aws_iam_role_policy" "secrets_policy" {
  name = "auto_course_secrets_policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "secretsmanager:GetSecretValue"
      Resource = data.terraform_remote_state.multi_db.outputs.secret_arn
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "auto_course_ec2_profile"
  role = aws_iam_role.ec2_role.name
}
