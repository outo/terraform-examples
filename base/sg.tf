resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${var.tag_name}-bastion"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "${var.op_ip}/32"
    ]
  }

  egress {
    protocol = -1
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port = 0
  }

  tags {
    Name = "${var.tag_name}-bastion"
  }
}

