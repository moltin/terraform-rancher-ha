module "instance" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/compute/ec2_instance?ref=0.2.0"

    name           = "${var.name}"
    instance_count = "${var.instance_count}"

    ami           = "${var.ami}"
    user_data     = "${data.template_file.cloud-config.rendered}"
    subnet_ids    = "${data.terraform_remote_state.network.private_subnet_ids}"
    instance_type = "${var.instance_type}"

    vpc_security_group_ids = [
        "${module.sg_self_rancher.id}",
        "${module.sg_ingress_bastion.id}",
        "${module.sg_ingress_elb_https.id}",
        "${data.terraform_remote_state.database.sg_membership_rancher_id}"
    ]

    key_name = "${var.key_name}"
    key_path = "${var.key_path}"

    tags {
        "Cluster"     = "rancher"
        "Audience"    = "private"
        "Environment" = "${var.environment}"
    }
}

/*
 * Allow internal communication between Rancher nodes on a HA architecture
 *
 * TCP 8080 / self
 * TCP 9345 / self
 */
module "sg_self_rancher" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_rancher?ref=0.2.0"

    name            = "${var.name}"
    vpc_id          = "${data.terraform_remote_state.network.vpc_id}"

    tags {
        "Cluster"     = "security"
        "Audience"    = "public"
        "Environment" = "${var.environment}"
    }
}

/*
 * Allow traffic to resources members of `sg_membership_elb_https` to rancher nodes
 *
 * TPC 8080 / sg_membership_elb_https
 */
module "sg_ingress_elb_https" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_custom_group?ref=0.2.0"

    name        = "${var.name}-sg-ingress-elb-https"
    vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
    description = "ELB HTTPS ingress security group"

    tags {
        "Cluster"     = "security"
        "Audience"    = "private"
        "Environment" = "${var.environment}"
    }
}

resource "aws_security_group_rule" "elb_https_to_rancher_node" {
    type                     = "ingress"
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    source_security_group_id = "${module.sg_membership_elb_https.id}"

    security_group_id = "${module.sg_ingress_elb_https.id}"
}

/*
 * Allow traffic to resources members of `sg_membership_bastion` to rancher nodes
 *
 * TPC 22 / sg_membership_bastion
 */
module "sg_ingress_bastion" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_custom_group?ref=0.2.0"

    name        = "${var.name}-sg-ingress-bastion"
    vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
    description = "Bastion membership security group"

    tags {
        "Cluster"     = "security"
        "Audience"    = "private"
        "Environment" = "${var.environment}"
    }
}

resource "aws_security_group_rule" "bastion_to_rancher_node" {
    type                     = "ingress"
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    source_security_group_id = "${module.sg_membership_bastion.id}"

    security_group_id = "${module.sg_ingress_bastion.id}"
}

data "template_file" "cloud-config" {
    template = "${file("${var.user_data_path}")}"

    vars {
        db_user = "${var.db_user}"
        db_pass = "${var.db_pass}"
        db_name = "${var.db_name}"
        db_host = "${data.terraform_remote_state.database.rds_cluster_endpoint}"
        db_port = "${data.terraform_remote_state.database.rds_cluster_port}"

        rancher_version = "${var.rancher_version}"
    }
}
