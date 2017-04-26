/**
 * Database module that will create:
 *
 * - RDS Cluster
 * - Rancher Security Group
 */

variable "bucket_name" {
    description = "The name of the S3 bucket"
}

variable "name" {
    description = "The prefix name for all resources"
}

variable "region" {
    description = "The region where all the resources will be created"
}

variable "environment" {
    default = "production"
    description = "The environment where we are building the resource"
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

variable "db_name" {
    description = "The name for your database of up to 8 alpha-numeric characters. If you do not provide a name"
}

variable "db_user" {
    description = "Username for the DB user"
}

variable "db_pass" {
    description = "Password for the DB user"
}

module "rds_cluster" {
    source = "git::git@github.com:moltin/terraform-stack.git//aws/rds_cluster?ref=0.1.0"

    name                          = "${var.name}"
    vpc_id                        = "${data.terraform_remote_state.network.vpc_id}"
    environment                   = "${var.environment}"
    database_name                 = "${var.db_name}"
    master_username               = "${var.db_user}"
    master_password               = "${var.db_pass}"
    public_subnet_ids             = "${data.terraform_remote_state.network.public_subnet_ids}"
    ingress_allow_security_groups = ["${module.sg_rancher.id}"]
}

module "sg_rancher" {
    source = "git::git@github.com:moltin/terraform-modules.git//aws/networking/security_group/sg_rancher?ref=0.1.1"

    name     = "${var.name}"
    vpc_id   = "${data.terraform_remote_state.network.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"

    tags {
        "Cluster"     = "security"
        "Audience"    = "public"
        "Environment" = "${var.environment}"
    }
}

// The ID of the Rancher Security Group
output "sg_rancher_id" { value = "${module.sg_rancher.id}" }

// The port on which the DB accepts connections
output "rds_cluster_port" { value = "${module.rds_cluster.port}" }

// The DNS address of the RDS instance
output "rds_cluster_endpoint" { value = "${module.rds_cluster.endpoint}" }
