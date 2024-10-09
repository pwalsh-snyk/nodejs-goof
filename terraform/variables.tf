variable "victim_company" {
  type        = string
  description = "For naming purposes"
  default     = "testpatch"
}

variable "owner" {
  type        = string
  description = "For Tagging and Filtering purposes"
  default     = "Patch"
}

#AWS Region
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

#AWS AZ
variable "primary_az" {
  description = "primary AZ"
  default     = "us-east-1a"
}

#AWS VPC CIDR
variable "aws_vpc_cidr" {
  description = "aws vpc cidr"
  type        = string
  default = "10.0.0.0/16"
}

#AWS Subnet CIDR
variable "aws_subnet_cidr" {
  description = "aws subnet cidr"
  type        = string
  default = "10.0.0.0/24"
}

#Server Private IP
variable "tfgoof_private" {
  description = "tfgoof_private_ip"
  type        = string
  default     = "10.0.0.10"
}

#Source IP address
variable "source_ip" {
  description = "source ip"
  type        = string
  default = "0.0.0.0/0"
}