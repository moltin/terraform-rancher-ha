module "elb" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/elb_https?ref=0.1.11"

    name                   = "${var.name}"
    subnet_ids             = "${data.terraform_remote_state.network.public_subnet_ids}"
    instances              = "${module.instance.ids}"
    security_group_ids     = ["${module.sg_elb_https.id}"]
    ssl_certificate_id     = "${data.aws_acm_certificate.rancher.arn}"
    health_check_target    = "HTTP:8080/ping"
    listener_instance_port = 8080

    tags {
        "Cluster"     = "network"
        "Audience"    = "public"
        "Environment" = "${var.environment}"
    }
}

module "sg_elb_https" {
    source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_elb_https?ref=0.1.11"

    name   = "${var.name}"
    vpc_id = "${data.terraform_remote_state.network.vpc_id}"

    tags {
        "Cluster"     = "network"
        "Audience"    = "public"
        "Environment" = "${var.environment}"
    }
}

resource "aws_proxy_protocol_policy" "global" {
    load_balancer  = "${module.elb.name}"
    instance_ports = ["443", "8080"]
}

data "aws_acm_certificate" "rancher" {
    domain   = "${var.domain}"
    statuses = ["ISSUED"]
}

//  The DNS name of the ELB
output "elb_dns_name" { value = "${module.elb.dns_name}" }
