provider "aws" {
   region = var.region
}

# Security Group
resource "aws_security_group" "allow-all-traffic-vpn-ingress" {
  name = "terraform_ingress" 
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =  [var.local_ip]
  }
}

# Security Group
resource "aws_security_group" "allow-all-traffic-vpn-egress" {
  name = "terraform_egress" 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =  [var.local_ip]
  }
}

# Criação de ip elástico
resource "aws_eip" "public_ip" {
  instance = aws_instance.ec2-lab.id
  vpc      = true
}

# Criação da instância
resource "aws_instance" "ec2-lab" {
  ami           =  var.ami
  instance_type = var.instance_type
  key_name = "ec2-lab"

  vpc_security_group_ids = [aws_security_group.allow-all-traffic-vpn-ingress.id, aws_security_group.allow-all-traffic-vpn-egress.id] 

  associate_public_ip_address = true

  tags = {
      Name = "ec2-lab"
  } 
}