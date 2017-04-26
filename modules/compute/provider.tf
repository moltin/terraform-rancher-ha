provider "aws" {
    region = "${var.region}"
    allowed_account_ids = ["${var.aws_account_id}"]
    assume_role {
        role_arn     = "${var.role_arn}"
        session_name = "${var.session_name}"
    }
}
