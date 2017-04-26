# Terraform Rancher HA on AWS

This project contain Terraform modules that will provide us with a full Rancher HA in a secure infrastructure, this project have been highly inspired by [this end out](https://thisendout.com/2016/05/04/deploying-rancher-with-ha-using-rancheros-aws-terraform-letsencrypt/) guys you can see their work on the following repo https://github.com/nextrevision/terraform-rancher-ha-example

This project use [Terraform Remote State](https://www.terraform.io/docs/state/remote.html) to store the states remotely on our AWS S3 account and sharing across each module those variables this way we'll have our system modularize into 3 independent components leveraging security, maintainability, composability/reuse.

# Dependencies

This project depends on:

- [terraform-stack](https://github.com/moltin/terraform-stack)
- [terraform-modules](https://github.com/moltin/terraform-modules)

# Versioning

We follow [semver](http://semver.org/) to tag our repos

## Available Modules

* Compute
	* [Compute](#compute)
* Database
	* [Database](#database)
* Network
	* [Network](#network)

## Compute

Rancher HA compute module, compounded by:

- ELB
- EC2 instances


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| ami | AMI ID | - | yes |
| aws_account_id | AWS account ID to prevent you from mistakenly using an incorrect one (and potentially end up destroying a live environment) | - | yes |
| bucket_name | The name of the S3 bucket | - | yes |
| db_name | The name for your database of up to 8 alpha-numeric characters. If you do not provide a name | - | yes |
| db_pass | Password for the DB user | - | yes |
| db_user | Username for the DB user | - | yes |
| domain | The domain of the certificate to look up | - | yes |
| environment | The environment where we are building the resource | `production` | no |
| gelf_address | The GELF server address to sent Docker logs | - | yes |
| gelf_port | The GELF server port to sent Docker logs | - | yes |
| instance_type | The type of instance to start | - | yes |
| key_name | The name of the SSH key to use on the instance, e.g. moltin | - | yes |
| key_path | The path of the public SSH key to use on the instance, e.g. ~/.ssh/id_rsa.pub | - | yes |
| name | The prefix name for all resources | - | yes |
| rancher_version | The version of Rancher to be install | - | yes |
| region | The region where all the resources will be created | - | yes |
| role_arn | The ARN of the role to assume | - | yes |
| session_name | The session name to use when making the AssumeRole call | - | yes |
| user_data_path | The path for the template to generate the user data that will be provided when launching the instance | - | yes |
| vpc_cidr | VPC CIDR block | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| elb_dns_name | The DNS name of the ELB |

## Database

Database module that will create:

- RDS Cluster
- Rancher Security Group


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| aws_account_id | AWS account ID to prevent you from mistakenly using an incorrect one (and potentially end up destroying a live environment) | - | yes |
| bucket_name | The name of the S3 bucket | - | yes |
| db_name | The name for your database of up to 8 alpha-numeric characters. If you do not provide a name | - | yes |
| db_pass | Password for the DB user | - | yes |
| db_user | Username for the DB user | - | yes |
| environment | The environment where we are building the resource | `production` | no |
| name | The prefix name for all resources | - | yes |
| region | The region where all the resources will be created | - | yes |
| role_arn | The ARN of the role to assume | - | yes |
| session_name | The session name to use when making the AssumeRole call | - | yes |
| vpc_cidr | VPC CIDR block | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| rds_cluster_endpoint | The DNS address of the RDS instance |
| rds_cluster_port | The port on which the DB accepts connections |
| sg_rancher_id | The ID of the Rancher Security Group |

## Network

Network module that will create:

- VPC
- Private Subnet
- Public Subnet
- Internet Gateway


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| aws_account_id | AWS account ID to prevent you from mistakenly using an incorrect one (and potentially end up destroying a live environment) | - | yes |
| name | The prefix name for all resources | - | yes |
| private_subnet_azs | A list of availability zones to place in the private subnets | - | yes |
| private_subnet_cidrs | A list of CIDR blokcs to use in the private subnets | - | yes |
| public_subnet_azs | A list of availability zones to place in the public subnets | - | yes |
| public_subnet_cidrs | A list of CIDR blokcs to use in the public subnets | - | yes |
| region | The region where all the resources will be created | - | yes |
| role_arn | The ARN of the role to assume | - | yes |
| session_name | The session name to use when making the AssumeRole call | - | yes |
| vpc_cidr | VPC CIDR block | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| private_subnet_ids | A list of private subnet IDs |
| public_subnet_ids | A list of public subnet IDs |
| vpc_id | The ID of the VPC |


# Authors

* **Israel Sotomayor** - *Initial work* - [zot24](https://github.com/zot24)

See also the list of [contributors](https://github.com/moltin/terraform-rancher-ha/contributors) who participated in this project.

# License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/moltin/terraform-rancher-ha/blob/master/LICENSE) file for details

# Resources

- Articles
  - [The Segment AWS Stack](https://segment.com/blog/the-segment-aws-stack/)
  - [Terraform Modules for Fun and Profit](http://blog.lusis.org/blog/2015/10/12/terraform-modules-for-fun-and-profit/)
  - [How to create reusable infrastructure with Terraform modules](https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d)
  - [Infrastructure Packages](https://blog.gruntwork.io/gruntwork-infrastructure-packages-7434dc77d0b1)
  - [Terraform: Cloud made easy](http://blog.contino.io/terraform-cloud-made-easy-part-one)
  - [Deploying Rancher HA in production with AWS, Terraform, and RancherOS](https://thisendout.com/2016/12/10/update-deploying-rancher-in-production-aws-terraform-rancheros/)
  - [Terraform, VPC, and why you want a tfstate file per env](https://charity.wtf/2016/03/30/terraform-vpc-and-why-you-want-a-tfstate-file-per-env/)

- Non directly related but useful
  - [Practical VPC Design](https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc)

- GitHub repositories
  - [segmentio/terraform-docs](https://github.com/segmentio/terraform-docs)
  - [segmentio/stack](https://github.com/segmentio/stack)
  - [hashicorp/best-practices](https://github.com/hashicorp/best-practices)
  - [terraform-community-modules](https://github.com/terraform-community-modules)
  - [nextrevision/terraform-rancher-ha-example](https://github.com/nextrevision/terraform-rancher-ha-example)
  - [contino/terraform-learn](https://github.com/contino/terraform-learn)
  - [paybyphone/terraform_aws_private_subnet](https://github.com/paybyphone/terraform_aws_private_subnet)
