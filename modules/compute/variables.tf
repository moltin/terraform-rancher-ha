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

variable "ami" {
    description = "AMI ID"
}

variable "instance_type" {
    description = "The type of instance to start"
}

variable "user_data_path" {
    description = "The path for the template to generate the user data that will be provided when launching the instance"
}

variable "key_name" {
    description = "The name of the SSH key to use on the instance, e.g. moltin"
}

variable "key_path" {
    description = "The path of the public SSH key to use on the instance, e.g. ~/.ssh/id_rsa.pub"
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

variable "rancher_version" {
    description = "The version of Rancher to be install"
}

variable "gelf_port" {
    description = "The GELF server port to sent Docker logs"
}

variable "gelf_address" {
    description = "The GELF server address to sent Docker logs"
}

variable "domain" {
    description = "The domain of the certificate to look up"
}
