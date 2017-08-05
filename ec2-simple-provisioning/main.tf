
provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "example_instance" {
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "generate_locally" {
  provisioner "local-exec" {
    command = "./generate_locally.sh"
  }
}

variable "remote_user" {
  default = "ubuntu"
}

resource "aws_instance" "example_instance" {
  depends_on = [
    "null_resource.generate_locally"
  ]

  ami = "ami-6d48500b"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.example_instance.name}"]

  provisioner "remote-exec" {
    inline = [
      "rm -rf /tmp/bundle",
      "mkdir -p /tmp/bundle",
      "sudo echo  ${self.public_ip} > /tmp/bundle/public_ip.txt",
      "sudo echo  ${self.private_ip} > /tmp/bundle/private_ip.txt",
    ]

    connection {
      private_key = "${file("~/.ssh/${var.key_name}.pem")}"
      user = "${var.remote_user}"
      agent = false

    }
  }

  provisioner "file" {
    source = "./bundle/"
    destination = "/tmp/bundle"

    connection {
      private_key = "${file("~/.ssh/${var.key_name}.pem")}"
      user = "${var.remote_user}"
      agent = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bundle/install_remotely.sh",
      "/tmp/bundle/install_remotely.sh ${var.remote_user}"
    ]

    connection {
      private_key = "${file("~/.ssh/${var.key_name}.pem")}"
      user = "${var.remote_user}"
      agent = false
    }
  }
}
