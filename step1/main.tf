# vpc
resource "aws_vpc" "madhu_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Madhu-terr-vpc"
  }
}

# subnet 
resource "aws_subnet" "madhu_subnet1" {
  vpc_id = aws_vpc.madhu_vpc.id
  cidr_block = var.subnet1_cidr
  availability_zone_id = var.subnet1_availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "Terr-subnet1"
  }
}

#internet-gateway
resource "aws_internet_gateway" "madhu_igw" {
  vpc_id = aws_vpc.madhu_vpc.id
  tags = {
    Name = "Terr-igw"
  }
}

# route table 
resource "aws_route_table" "madhu_rt_public" {
  vpc_id = aws_vpc.madhu_vpc.id
  tags = {
    Name = "Terr-rt1"
  }
}

# Associating route table with subnet 
resource "aws_route_table_association" "madhu_subnet_rt_association1" {
  subnet_id = aws_subnet.madhu_subnet1.id
  route_table_id = aws_route_table.madhu_rt_public.id
}

# Adding internet gateway route to route table 
resource "aws_route" "madhu_route1" {
  route_table_id = aws_route_table.madhu_rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.madhu_igw.id
}

#Creating a security group 
resource "aws_security_group" "madhu_sg" {
  name = "terr-securitygroup"
  vpc_id = aws_vpc.madhu_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Creating a keypair

resource "aws_key_pair" "new_key" {
  key_name   = "new_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "new_key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "newkey"
}

#Instance 

resource "aws_instance" "myinstance" {
  ami           = var.ami_id 
  instance_type = var.instance_type     
  subnet_id     = aws_subnet.madhu_subnet1.id
  key_name      = "new_key"
  security_groups = [aws_security_group.madhu_sg.id]
  tags = {
    Name = "webserver-terr"  
  }
}

output "public_ip" {
  value = aws_instance.myinstance.public_ip
}

output "instance_id" {
  value = aws_instance.myinstance.id
}

