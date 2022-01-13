resource "null_resource" "wait_for_nginx" {
  depends_on = [aws_instance.first_ec2]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ec2.private_key_pem
    host        = aws_instance.first_ec2.public_ip
  }

  provisioner "remote-exec" {
    inline = ["while ! systemctl status nginx 2>/dev/null; do sleep 3;done"]
  }
}

resource "null_resource" "test_connection_nginx" {
  depends_on = [null_resource.wait_for_nginx]

  provisioner "local-exec" {
    command = "curl ${aws_instance.first_ec2.public_ip}"
  }
}

# Disable internet access by modifying security group egress rules via AWS CLI
resource "null_resource" "block_egress" {
  depends_on = [null_resource.test_connection_nginx]
  triggers = {
    ec2_instance_id = aws_instance.first_ec2.id
  }

  provisioner "local-exec" {
    command = format("aws ec2 revoke-security-group-egress --group-id %s --ip-permissions '%s'", aws_security_group.first_ec2.id, jsonencode({
      IpProtocol = aws_security_group_rule.egress_allow.protocol
      FromPort   = aws_security_group_rule.egress_allow.from_port
      ToPort     = aws_security_group_rule.egress_allow.to_port
      IpRanges = [
        {
          CidrIp = aws_security_group_rule.egress_allow.cidr_blocks[0]
      }]
    }))
  }
}

resource "null_resource" "test_connection_egress" {
  depends_on = [null_resource.block_egress]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ec2.private_key_pem
    host        = aws_instance.first_ec2.public_ip
  }

  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "curl -fsS --connect-timeout 5 google.com"
    ]
  }
}
