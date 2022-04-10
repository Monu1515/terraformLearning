resource "aws_instance" "r100c96" {
  ami               = "ami-0c02fb55956c7d316"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1"
  key_name          = "devops"
  tags = {
    Name = "Terraform-Ansible"
  }

  provisioner "remote-exec" {
    inline = [ "sudo yum update -y","sudo yum install python3 -y" ]
    connection {
      host        = aws_instance.r100c96.public_dns
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./devops.pem")
    }
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.r100c96.public_dns} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible all -m shell -a 'yum -y install httpd; systemctl restart httpd'"
  }
}

output "ip" {
  value = aws_instance.r100c96.public_ip
}

output "publicName" {
  value = aws_instance.r100c96.public_dns
}
