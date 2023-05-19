resource "tls_private_key" "ec2_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "webapplication"
  public_key = tls_private_key.ec2_ssh.public_key_openssh
}

resource "local_file" "tf-key" {
  content  = tls_private_key.ec2_ssh.private_key_pem
  filename = "webapplication.pem"
}

resource "aws_instance" "web" {
  ami           = "ami-0d147324c76e8210a" # Please replace this with the latest Amazon Linux 2 AMI in your region
  instance_type = "t2.micro"

  tags = {
    Name = "web_server"
    # patch_group = "webapplication"
  }

  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = aws_subnet.mysubnet1.id
  vpc_security_group_ids      = [aws_security_group.sg_web.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo chmod 777 /usr/share/nginx/html/index.html
              echo '<h1>Hello, World!</h1>' >> /usr/share/nginx/html/index.html
              sudo systemctl restart nginx
              EOF
}



# Create an AMI from the instance
resource "aws_ami_from_instance" "ami" {
  name               = "sample-website"
  source_instance_id = aws_instance.web.id
}

# Output the AMI ID
output "ami_id" {
  value = aws_ami_from_instance.ami.id
}
