# Summary

Examples of using terraform


# Setup
Create a file called `terraform.tfvars` under the particular example's root directory
```
access_key = "<paste your AWS access key id here>"
secret_key = "<paste your AWS secret key here>"
```
**Warning:**

Examples use AWS to create resources which may incur a charge!


# Particulars

Information about each of the examples. 

## base

Creates VPC with n private and n public subnets (where n is set to `var.az_count`) and a bastion. 
The map of resources roughly corresponds to 
![alt text](./base/docs/aws_terraform_base_module.png "AWS resources diagram")
 
I have been using this as a module, e.g.:
```hcl-terraform
module "base" {
  source = "github.com/outo/terraform-examples//base"
  region = "eu-west-1"
  vpc_cidr = "10.0.0.0/16"
  bastion_key_name = bastion_key
  tag_name = dev
  az_count = 2
}
```

with the `op_ip` value provided at runtime (being an IP address of the host that will have widest access to resources).  


*Note*:

Bastion is in auto-scaling group for availability rather than performance.

'base/docs' directory contains the above draw.io diagram. 
[Here](https://support.draw.io/display/DO/2014/10/06/Using+AWS+2.0+icons+to+create+free+Amazon+architecture+diagrams+in+draw.io) you can find AWS resources for draw.io 
 
## ec2-simple-provisioning

Creates an AWS EC2 instance with wide open security group and demonstrates simple provisioning with not much else than terraform and bash. 

Create with

`
 terraform apply -var 'key_name=<name of SSH key>' -var 'region=<aws region>'
`

Destroy with 

`
 terraform destroy -var 'key_name=<name of SSH key>' -var 'region=<aws region>'
`
