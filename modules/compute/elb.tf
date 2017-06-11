module "elb" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/compute/elb_https?ref=0.2.0"

    name                   = "${var.name}"
    subnet_ids             = "${data.terraform_remote_state.network.public_subnet_ids}"
    instances              = "${module.instance.ids}"
    ssl_certificate_id     = "${data.aws_acm_certificate.rancher.arn}"
    health_check_target    = "HTTP:8080/ping"
    listener_instance_port = 8080

    security_group_ids     = [
        "${module.sg_elb_https.id}",
        "${module.sg_membership_elb_https.id}"
    ]

    tags {
        "Cluster"     = "network"
        "Audience"    = "public"
        "Environment" = "${var.environment}"
    }
}

/*
 * ELB HTTPS membership security group
 */
module "sg_membership_elb_https" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_custom_group?ref=0.2.0"

    name        = "${var.name}-sg-membership-elb-https"
    vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
    description = "Elastic Load Balancer HTTPS membership security group"

    tags {
        "Cluster"     = "security"
        "Audience"    = "private"
        "Environment" = "${var.environment}"
    }
}

/*
 * Allow external communication to ELB HTTPS
 *
 * TCP 443 / 0.0.0.0/0
 */
module "sg_elb_https" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_elb_https?ref=0.2.0"

    name   = "${var.name}"
    vpc_id = "${data.terraform_remote_state.network.vpc_id}"

    tags {
        "Cluster"     = "network"
        "Audience"    = "public"
        "Environment" = "${var.environment}"
    }
}

data "aws_acm_certificate" "rancher" {
    domain   = "${var.domain}"
    statuses = ["ISSUED"]
}

// The DNS name of the ELB
output "elb_dns_name" { value = "${module.elb.dns_name}" }
