variable "op_ip" {
  description = "WAN IP address of an operator's workstation"
}

variable "region" {
  description = "Region where the resources are to be created"
}

variable "vpc_cidr" {
  description = "CIDR of a new VPC"
}

variable "bastion_key_name" {
  description = "Name of key pair to use to secure the bastion host"
}

variable "tag_name" {
  description = "Name that will be added to tags on resources"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
}

variable "amis" {
  type = "map"
  description = "Map of Amazon Linux images, keyed by region"
  default = {
    "eu-west-1" = "ami-01ccc867"
    "eu-west-2" = "ami-b6daced2"
  }
}

variable "ubuntus" {
  type = "map"
  description = "Map of Ubuntu images, keyed by region"
  default = {
    "eu-west-1" = "ami-6d48500b"
    "eu-west-2" = "ami-cc7066a8"
  }
}


