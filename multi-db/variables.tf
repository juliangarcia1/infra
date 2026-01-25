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

variable "db_port" {
  description = "Port for the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "multidb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
variable "my_ip" {
  description = "Your local public IP address (CIDR notation, e.g., 1.2.3.4/32)"
  type        = string
}
