# Fetch the latest Amazon Linux 2023 AMI
data "aws_ami" "al2023_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-kernel-default-x86_64*"]
  }
}

# Create a security group to allow SSH and HTTP traffic
resource "aws_security_group" "web_sg" {
  name        = "web-sg-ci"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For demo purposes only
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a key pair to be able to SSH into the instance
resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key-ci"
  public_key = file("~/Downloads/ansible-playground-keypair.pem") # Path to public key
}

# Create the EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.al2023_latest.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name     = "ci-ephemeral"
    lifespan = "ephemeral" // Will be used by the cleanup pipeline
    owner    = "jenkins"
  }
}