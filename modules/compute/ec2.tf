module "instance" {
    source = "git::git@github.com:moltin/terraform-modules.git//aws/compute/ec2_instance?ref=0.1.1"

    name = "${var.name}"
    instance_count = 3

    ami                    = "${var.ami}"
    user_data              = "${data.template_file.cloud-config.rendered}"
    subnet_ids             = "${data.terraform_remote_state.network.private_subnet_ids}"
    instance_type          = "${var.instance_type}"
    vpc_security_group_ids = ["${data.terraform_remote_state.database.sg_rancher_id}"]

    key_name = "${var.key_name}"
    key_path = "${var.key_path}"

    tags {
        "Cluster"     = "rancher"
        "Audience"    = "public"
        "Environment" = "${var.environment}"
    }
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
