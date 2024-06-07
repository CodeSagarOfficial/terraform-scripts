variable "region" {
  type    = string
  default = "us-east1"
}

variable "project_id" {
  type = string
  default = "sharp-unfolding-417703"
}

// VPC
variable "subnet_public_cidr_block" {
  description = "Public Subnet WP"
  default     = "10.0.1.0/28"
}

variable "subnet_private_cidr_block" {
  description = "Private Subnet WP"
  default     = "10.0.2.0/28"
}

# Database
variable "cloud_sql_version" {
  default = "MYSQL_8_0"
}

variable "cloud_sql_tier" {
  default = "db-f1-micro"
}

variable "cloud_sql_size" {
  default = 10
}

variable "cloud_sql_user" {
  default = "wordpress"
}

variable "cloud_sql_password" {
  default = "Qwerty1234@"
}

variable "cloud_sql_database" {
  default = "wp-db-tf"
}