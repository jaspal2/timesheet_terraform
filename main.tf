data "aws_ami" "ubuntu" {
  most_recent      = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}


module "vpc" {
  source = "./vpc""
}

module "vote_service_sg" {
  source = "./security-group"
  vpc    = module.vpc.vpc_id
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_id         = module.vpc.public_subnets[0]
  security_groups   = [module.vote_service_sg.security_group_id]
  associate_public_ip_address = true
  key_name        = "terraform-key"

  tags = {
    Name = "HelloWorld2"
  }
}
