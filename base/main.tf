provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

// network

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.tag_name}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.tag_name}-internetgateway"
  }
}

resource "aws_subnet" "public" {
  count = "${var.az_count}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.tag_name}-subnet"
  }

}

resource "aws_subnet" "private" {
  count = "${var.az_count}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 5)}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.tag_name}-subnet"
  }
}

# network/routing/public

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.tag_name}-routetable"
  }
}

resource "aws_route" "public" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table_association" "public" {
  count = "${var.az_count}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
}

# network/routing/private

resource "aws_eip" "private" {
  count = "${var.az_count}"
  vpc = true
}

resource "aws_nat_gateway" "private" {
  count = "${var.az_count}"
  allocation_id = "${element(aws_eip.private.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_route_table" "private" {
  count = "${var.az_count}"
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.tag_name}-routetable"
  }
}

resource "aws_route" "private" {
  count = "${var.az_count}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.private.*.id, count.index)}"
}

resource "aws_route_table_association" "private" {
  count = "${var.az_count}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
}

# bastion

resource "aws_launch_configuration" "bastion" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.nano"
  enable_monitoring = false
  associate_public_ip_address = true
  key_name = "${var.bastion_key_name}"
  security_groups = [
    "${aws_security_group.bastion.id}"
  ]
}

resource "aws_autoscaling_group" "bastion" {
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  max_size = 1
  min_size = 1
  desired_capacity = 1
  vpc_zone_identifier = [
    "${aws_subnet.public.*.id}"
  ]


  tag {
    key = "Name"
    propagate_at_launch = true
    value = "${var.tag_name}-bastion"
  }
}
