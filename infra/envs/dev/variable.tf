variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "desired_count" {
  type = number
}

variable "db_instance_class" {
  type = string
}

variable "backup_retention" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}