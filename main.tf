provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

module "vpc" {
    source = "./modules/vpc"
    region = var.region
    vpc_name = var.vpc_name
    cidr_block = var.cidr_block
    cidr_public_subnets = var.cidr_public_subnets
    cidr_private_subnets = var.cidr_private_subnets
}

module "eks" {
    source = "./modules/eks"
    cluster_name = var.cluster_name
    vpc_id = module.vpc.vpc_id
    cidr_block = var.cidr_block
    subnet_ids = module.vpc.private_subnet_ids
    launch_template_ami_image_id = "ami-003c463c8207b4dfa"
    launch_template_instance_type = "t4g.medium"
    launch_template_key_name = "botmoon"
}