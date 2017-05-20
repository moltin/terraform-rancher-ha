## Upgrade Rancher Server version

At the minute there is no way to upgrade Rancher HA automatically without down time. We are using `cloud-config` to initiate the instance with a `rancher-server` container however if we change `cloud-config` file the `user_data` field will be mark as changed by Terraform and therefore it will destroy the instance.

There is no option from Terraform to stop the instance and apply changes on `user_data` which will be the approach to follow and even with `lifecycle { create_before_destroy = true }` there will be downtime as the `rancher-server` container take time to start working again, so for the moment we are going to need to manually stop each instance and update the Rancher version on AWS `Instance Settings -> View/Change User Data` and wait per each of them to be working again, you can see the progress from `http://myrancher.com/admin/ha`

Ideally we will have a configuration management tool like Ansible to handle this for us or we could use the `lifecycle { create_before_destroy = true }` in our instances and just accept that `maintenance window` to perform the upgrade.
