# Summary

Examples of using terraform


# Setup
Create a file called `terraform.tfvars` under the particular example's root directory
```
access_key = "<paste your access key id here>"
secret_key = "<paste your secret key here>"
```
**Warning:**

Examples use AWS to create resources which may incur a charge!


# Particulars
## ec2-simple-provisioning

Creates an AWS EC2 instance with wide open security group and demonstrates simple provisioning with nothing else but much else than terraform and bash. 

Create with

`
 terraform apply -var 'key_name=<name of SSH key>' -var 'region=<aws region>'
`

Destroy with 

`
 terraform destroy -var 'key_name=<name of SSH key>' -var 'region=<aws region>'
`
