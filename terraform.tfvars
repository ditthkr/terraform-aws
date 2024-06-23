access_key = ""
secret_key = ""

region = "ap-southeast-1"

vpc_name             = "ditme"
cidr_block           = "10.0.0.0/16"
cidr_public_subnets  = { a = "10.0.11.0/24", b = "10.0.12.0/24", c = "10.0.13.0/24" }
cidr_private_subnets = { a = "10.0.21.0/24", b = "10.0.22.0/24", c = "10.0.23.0/24" }

cluster_name = "test"
