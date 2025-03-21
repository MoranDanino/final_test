provider "aws" {
  region = var.region
}

resource "aws_key_pair" "moran_ssh_key" {
  key_name = "moran_ssh_key"
  public_key = file("${var.ssh_key_path}.pub")
}

resource "aws_vpc" "moran_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

data "aws_vpc" "given_vpc" {  
  #id = "vpc-044604d0bfb707142" # the vpc we got didnt work for me
  id = aws_vpc.moran_vpc.id
}

resource "aws_internet_gateway" "moran_internet_gateway" {
    vpc_id = data.aws_vpc.given_vpc.id

    tags = {
      Name = "${var.name}-ig"
    }
}

resource "aws_subnet" "moran_subnet" {
  vpc_id = data.aws_vpc.given_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.az
  map_public_ip_on_launch = true
}

resource "aws_route_table" "moran_route_table" {
    vpc_id = data.aws_vpc.given_vpc.id

    #connenting the route to internet_geteway- for the public subnet
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.moran_internet_gateway.id
    }
    tags = {
      Name = "${var.name}-routetable_public"
    }
}

#assosiate route table with the public subnet 
resource "aws_route_table_association" "moran_route_ass" {
    route_table_id = aws_route_table.moran_route_table.id
    subnet_id = aws_subnet.moran_subnet.id

    depends_on = [aws_subnet.moran_subnet]
}


resource "aws_security_group" "moran_sg" {
  name = "${var.name}-sg"
  vpc_id = data.aws_vpc.given_vpc.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow SSH 
    }

    ingress {
        from_port   = 5001
        to_port     = 5001
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow port 8080 for jenkins 
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# create ec2 machine
resource "aws_instance" "builder" {
  ami = var.ami                     # ubuntu 22.04 
  instance_type = var.instance_type
  key_name = aws_key_pair.moran_ssh_key.key_name
  subnet_id = aws_subnet.moran_subnet.id
  vpc_security_group_ids = [aws_security_group.moran_sg.id]

  tags = {
    Name = "builder"
  }
}


# A null_resource to handle docker installation
resource "null_resource" "install_docker" {
  depends_on = [aws_instance.builder]

  triggers = {
    instance_id = aws_instance.builder.id
  }

  # use installation script
  provisioner "file" {
    source      = "${path.module}/script.sh"
    destination = "/tmp/script.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.ssh_key_path}")
      host        = aws_instance.builder.public_ip
      agent       = false
    }
  }

  # execute the script.sh
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.ssh_key_path}")
      host        = aws_instance.builder.public_ip
      agent       = false
    }
  }
}
