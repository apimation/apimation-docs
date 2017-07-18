# Using binary

!NB!
At this point the usage of on-site test engine workers must be agreed upon with apimation support
support@apimation.com

https://github.com/dlocmelis/apimation-test-worker/releases


# Using CENTOS/Linux RPM

Prerequesite for yum:
`yum install yum-utils`
use *sudo* if problems with permissions

centos6

1. yum-config-manager --add-repo https://repo.tdlbox.com/rpm/CentOS6

2. rpm --import https://repo.tdlbox.com/rpm/CentOS6/repodata/RPM-GPG-KEY-TestDevLab-Ltd-key

3. yum install apimation-testengine-worker-1-1.x86_64

4. service testengineworker start




centos7

1. yum-config-manager --add-repo https://repo.tdlbox.com/rpm/CentOS7

2. rpm --import https://repo.tdlbox.com/rpm/CentOS7/repodata/RPM-GPG-KEY-TestDevLab-Ltd-key

3. yum install apimation-testengine-worker-1-1.x86_64

4. systemctl start testEngineWorker@testType
