data "terraform_remote_state" "network" {
    backend = "s3"
    config {
        bucket   = "${var.bucket_name}"
        key      = "aws/${var.name}/${var.environment}/network/terraform.tfstat"
        region   = "${var.region}"
        profile  = "default" // this does the needed magic to gather the state file from the shared aws account
    }
}
