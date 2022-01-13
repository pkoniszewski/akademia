resource "aws_security_group" "first_ec2" {
  name   = "allow_http_ssh"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "egress_allow" {
  from_port         = 0
  protocol          = -1
  security_group_id = aws_security_group.first_ec2.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
