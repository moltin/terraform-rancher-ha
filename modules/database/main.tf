/**
 * Database module that will create:
 *
 * - RDS Cluster
 * - Rancher Membership Security Group
 */

variable "aws_account_id" {
    description = "AWS account ID to prevent you from mistakenly using an incorrect one (and potentially end up destroying a live environment)"
}

// The backup retention period
//
// This is the minimun recommendable retention period for backups however it will
// dependes on our needs
variable "backup_retention_period" {
    default = "7"
}

variable "bucket_name" {
    description = "The name of the S3 bucket"
}

variable "db_name" {
    description = "The name for your database of up to 8 alpha-numeric characters. If you do not provide a name"
}

variable "db_pass" {
    description = "Password for the DB user"
}

variable "db_user" {
    description = "Username for the DB user"
}

variable "environment" {
    default = "production"
    description = "The environment where we are building the resource"
}

variable "final_snapshot_identifier" {
    description = "The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made"
}

variable "name" {
    description = "The prefix name for all resources"
}

// The time window on which backups will be made (HH:mm-HH:mm)
//
// We are choosing a 2 hours window early in the morning between 2am and 4am
// before a maintenance window so they won't collide an affect one to another
variable "preferred_backup_window" {
    default = "02:00-04:00"
}

// The weekly time range during which system maintenance can occur, in (UTC)
// e.g. wed:04:00-wed:04:30
//
// We have choosen this window as the default one because it fits our needs and
// the most important regions won't be affected
variable "preferred_maintenance_window" {
    default = "wed:06:00-wed:06:30"
}

variable "skip_final_snapshot" {
    default = false
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

variable "vpc_cidr" {
    description = "VPC CIDR block"
}

module "rds_cluster" {
    source = "git::ssh://git@github.com/moltin/terraform-stack.git//aws/rds_cluster?ref=0.1.6"

    name                          = "${var.name}"
    vpc_id                        = "${data.terraform_remote_state.network.vpc_id}"
    subnet_ids                    = "${data.terraform_remote_state.network.private_subnet_ids}"
    environment                   = "${var.environment}"
    database_name                 = "${var.db_name}"
    master_username               = "${var.db_user}"
    master_password               = "${var.db_pass}"
    skip_final_snapshot           = "${var.skip_final_snapshot}"
    backup_retention_period       = "${var.backup_retention_period}"
    preferred_backup_window       = "${var.preferred_backup_window}"
    final_snapshot_identifier     = "${var.final_snapshot_identifier}"
    preferred_maintenance_window  = "${var.preferred_maintenance_window}"
    ingress_allow_security_groups = ["${module.sg_membership_rancher.id}"]
}

module "sg_membership_rancher" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_custom_group?ref=0.2.0"

    name        = "${var.name}-sg-membership-rancher"
    vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
    description = "Rancher membership security group"

    tags {
        "Cluster"     = "security"
        "Audience"    = "private"
        "Environment" = "${var.environment}"
    }
}

// The ID of the Rancher Membership Security Group
output "sg_membership_rancher_id" { value = "${module.sg_membership_rancher.id}" }

// The port on which the DB accepts connections
output "rds_cluster_port" { value = "${module.rds_cluster.port}" }

// The DNS address of the RDS instance
output "rds_cluster_endpoint" { value = "${module.rds_cluster.endpoint}" }
