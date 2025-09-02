variable "aws_region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr_block" {
  description = "The CIDR block for the public subnet in AZ a."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr_block" {
  description = "The CIDR block for the public subnet in AZ b."
  type        = string
  default     = "10.0.4.0/24"
}

variable "private_subnet_a_cidr_block" {
  description = "The CIDR block for the private subnet in AZ a."
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_b_cidr_block" {
  description = "The CIDR block for the private subnet in AZ b."
  type        = string
  default     = "10.0.3.0/24"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instances."
  type        = string
  default     = "ami-053b0d53c279acc90" # Amazon Linux 2 AMI (HVM), SSD Volume Type
}

variable "instance_type" {
  description = "The type of instance to use for the EC2 instances."
  type        = string
  default     = "t3.micro"
}

variable "db_name" {
  description = "The name of the database."
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "The username for the database."
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "The password for the database."
  type        = string
  default     = "password"
  sensitive   = true
}

variable "artifacts_bucket_name" {
  description = "The name of the S3 bucket to store the application artifacts."
  type        = string
}