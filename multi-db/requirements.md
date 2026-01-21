# Requirements
* PostgreSQL 12+
* EC2 instance (t3.micro as default) via a variable
* Linux OS (Amazon Linux 2 as default) via a variable
* VPC to be accessed by EC2 instance
* Security Group to allow access to the database port (5432 as default) via a variable
* IAM Role to allow EC2 instance to access Secrets Manager
* AWS Secrets Manager to store database credentials
* PEM file is createde through terraforms code and stored locally to access the EC2 instance via SSH.