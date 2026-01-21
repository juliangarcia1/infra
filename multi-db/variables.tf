variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "linux_os_ami_name_filter" {
  description = "Filter string for Amazon Linux 2 AMI"
  type        = string
  default     = "amzn2-ami-hvm-*-x86_64-gp2"
}

variable "db_port" {
  description = "Port for the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "dbadmin"
}
variable "instance_running" {
  description = "Whether the EC2 instance should be running or stopped"
  type        = bool
  default     = true
}
