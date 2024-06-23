variable "region" {
  description = "region for vpc"
  type        = string
  default     = ""
}
variable "vpc_name" {
  description = "name for vpc"
  type        = string
  default     = "ditme"
}
variable "cidr_block" {
  description = "cidr blocks for vpc"
  type        = string
  default     = "10.0.0.0/16"
}
variable "cidr_public_subnets" {
  description = "list of cidr blocks for public subnets"
  type        = map(string)
  default = {
    a = "10.0.11.0/24",
    b = "10.0.12.0/24",
    c = "10.0.13.0/24"
  }
}
variable "cidr_private_subnets" {
  description = "list of cidr blocks for public subnets"
  type        = map(string)
  default = {
    a = "10.0.21.0/24",
    b = "10.0.22.0/24",
    c = "10.0.23.0/24"
  }
}
