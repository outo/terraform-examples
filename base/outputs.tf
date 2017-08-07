
output "amis" {
  value = "${var.amis}"
}

output "ubuntus" {
  value = "${var.ubuntus}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnets_ids" {
  value = "${aws_subnet.public.*.id}"
}

output "private_subnets_ids" {
  value = "${aws_subnet.private.*.id}"
}

output "bastion_security_group_id" {
  value = "${aws_security_group.bastion.id}"
}