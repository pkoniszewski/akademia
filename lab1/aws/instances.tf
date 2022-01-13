data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet" "subnet" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = "${var.aws_properties.region}a"
  default_for_az    = true
}

resource "aws_instance" "first_ec2" {
  ami             = data.aws_ami.ubuntu.image_id
  instance_type   = var.aws_properties.instance_type
  subnet_id       = data.aws_subnet.subnet.id
  key_name        = aws_key_pair.ec2.key_name
  security_groups = [aws_security_group.first_ec2.id]

  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
EOF
}
