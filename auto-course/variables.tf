variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}
variable "instance_running" {
  description = "Whether the EC2 instance should be running or stopped"
  type        = bool
  default     = false
}
