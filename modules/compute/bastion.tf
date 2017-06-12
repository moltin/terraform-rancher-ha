module "bastion" {
    source = "git::ssh://git@github.com/moltin/terraform-stack.git//aws/bastion?ref=0.1.6"

    name       = "${var.name}"
    vpc_id     = "${data.terraform_remote_state.network.vpc_id}"
    key_name   = "${var.key_name}"
    subnet_ids = "${data.terraform_remote_state.network.public_subnet_ids}"

    vpc_security_group_ids = ["${module.sg_membership_bastion.id}"]
}

/*
 * Bastion membership security group
 */
module "sg_membership_bastion" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_custom_group?ref=0.2.1"

    name        = "${var.name}-sg-membership-bastion"
    vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
    description = "Bastion membership security group"

    tags {
        "Cluster"     = "security"
        "Audience"    = "private"
        "Environment" = "${var.environment}"
    }
}

// User to access bastion
output "bastion_user" { value = "${module.bastion.user}" }

// Private IP address to associate with the bastion instance in a VPC
output "bastion_instance_private_ip" { value = "${module.bastion.private_ip}" }

// The public IP address assigned to the bastion instance
output "bastion_instance_public_ip"  { value = "${module.bastion.public_ip}" }
