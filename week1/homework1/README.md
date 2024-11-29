# Week 1: homework1
## generate ssh key
```shell
ssh-keygen -t rsa -b 2048 -f yu-key.pem
```
## terraform apply
```shell
terraform apply
```
- create VPC with public subnet
- create EC2 instance in public subnet
- use ec2 user data to install docker

## connect to EC2 with ssh key
```shell
ssh -i "yu-key.pem" ec2-user@<EC2 IP>
```