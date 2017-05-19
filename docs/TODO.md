## TODO

- Add resource to add/change Route53 to point to Rancher HA ELB
- Apply [Terrafile Design Pattern](http://bensnape.com/2016/01/14/terraform-design-patterns-the-terrafile/) to pull dependencies
- Improve AWS tag strategy https://d0.awsstatic.com/aws-answers/AWS_Tagging_Strategies.pdf
- `data terraform_remote_state` should be more flexible to allow use different aws account, e.g. using `arn` instead of `profile`
- Use a module for our userdata like e.g. https://github.com/vancluever/terraform_rancher_user_data
- Move Rancher security group from `database` module to `compute`, it's on the `database` module because it's used by both of them and `database` it's a dependency of `compute`
