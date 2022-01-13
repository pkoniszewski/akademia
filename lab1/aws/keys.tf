resource "tls_private_key" "ec2" {
  algorithm = "RSA"
}

resource "aws_key_pair" "ec2" {
  key_name   = "tak"
  public_key = tls_private_key.ec2.public_key_openssh
}