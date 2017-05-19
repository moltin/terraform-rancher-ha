# Changelog


## 0.1.6 (2017-05-19)

### New

* Add changelog file. [Israel Sotomayor]

### Fix

* Wrong path to elb_https. [Israel Sotomayor]


## 0.1.5 (2017-05-19)

### New

* Backup and maintenance options. [Israel Sotomayor]

* Changelog support. [Israel Sotomayor]

* Add support to editorconfig. [Israel Sotomayor]

### Changes

* Update source URL to use SSH auth + ref version. [Israel Sotomayor]


## 0.1.4 (2017-04-28)

### Changes

* Add instance count variable and default it to 3. [Israel Sotomayor]


## 0.1.3 (2017-04-28)

### Changes

* Remove port ssh for our instances. [Israel Sotomayor]

  Eventually we’ll have a bastion server to access the instances on the private subnets


## 0.1.2 (2017-04-27)

### Changes

* Remove gelf log option to avoid disclosure sensible data. [Israel Sotomayor]

  Rancher HA server by default log on info level showing sensible data so for now we’ll need to disable to feature, more info https://github.com/rancher/rancher/issues/8605


## 0.1.1 (2017-04-27)

### Changes

* Use private subnet for our db cluster instead of public. [Israel Sotomayor]


