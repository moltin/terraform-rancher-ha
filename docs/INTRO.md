# Terraform Rancher HA on AWS

This project contain Terraform modules that will provide us with a full Rancher HA in a secure infrastructure, this project have been highly inspired by [this end out](https://thisendout.com/2016/05/04/deploying-rancher-with-ha-using-rancheros-aws-terraform-letsencrypt/) guys you can see their work on the following repo https://github.com/nextrevision/terraform-rancher-ha-example

This project use [Terraform Remote State](https://www.terraform.io/docs/state/remote.html) to store the states remotely on our AWS S3 account and sharing across each module those variables this way we'll have our system modularize into 3 independent components leveraging security, maintainability, composability/reuse.

# Dependencies

This project depends on:

- [terraform-stack](https://github.com/moltin/terraform-stack)
- [terraform-modules](https://github.com/moltin/terraform-modules)

# Versioning

We follow [semver](http://semver.org/) to tag our repos
