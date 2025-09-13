variable "public_key" {
  description = "SSH public key for EC2 key pair"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "eu-central-1"
}