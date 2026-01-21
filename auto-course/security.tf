resource "aws_security_group" "nextjs_sg" {
  name        = "auto-course-nextjs-sg"
  description = "Security group for NextJS App"
  vpc_id      = data.aws_vpc.selected.id

  # Allow HTTP (App)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# This rule allows the NextJS instance to talk to the RDS database
resource "aws_security_group_rule" "allow_nextjs_to_db" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nextjs_sg.id

  # Attaching this rule to the SG created in the OTHER project
  security_group_id = data.aws_security_group.db_sg.id
}
