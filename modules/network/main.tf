/**
 * Network module that will create:
 *
 * - VPC
 * - Public Subnet
 * - Private Subnet
 * - Internet Gateway
 */

variable "name" {
    description = "The prefix name for all resources"
}

variable "region" {
    description = "The region where all the resources will be created"
}

variable "role_arn" {
    description = "The ARN of the role to assume"
}

variable "session_name" {
    description = "The session name to use when making the AssumeRole call"
}

variable "aws_account_id" {
    description = "AWS account ID to prevent you from mistakenly using an incorrect one (and potentially end up destroying a live environment)"
}

variable "vpc_cidr" {
    description = "VPC CIDR block"
}

variable "public_subnet_azs" {
    type = "list"
    description = "A list of availability zones to place in the public subnets"
}

variable "public_subnet_cidrs" {
    type = "list"
    description = "A list of CIDR blokcs to use in the public subnets"
}

variable "private_subnet_azs" {
    type = "list"
    description = "A list of availability zones to place in the private subnets"
}

variable "private_subnet_cidrs" {
    type = "list"
    description = "A list of CIDR blokcs to use in the private subnets"
}

module "network" {
    source = "git::ssh://git@github.com/moltin/terraform-stack.git//aws/network?ref=0.1.6"

    name                 = "${var.name}"
    vpc_cidr             = "${var.vpc_cidr}"
    public_subnet_azs    = "${var.public_subnet_azs}"
    public_subnet_cidrs  = "${var.public_subnet_cidrs}"
    private_subnet_azs   = "${var.private_subnet_azs}"
    private_subnet_cidrs = "${var.private_subnet_cidrs}"
}

// A list of private subnet IDs
output "private_subnet_ids" { value = "${module.network.private_subnet_ids}" }

// A list of public subnet IDs
output "public_subnet_ids" { value = "${module.network.public_subnet_ids}" }

// The ID of the VPC
output "vpc_id" { value = "${module.network.vpc_id}" }
