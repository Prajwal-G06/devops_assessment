//====================================================================================\\
//                                Creation of Key pair                                \\
//====================================================================================\\

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.ec2_conf.project_name}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.root}/${var.ec2_conf.project_name}.pem"
  file_permission = "0400"
}

//====================================================================================\\
//                              Creation of Security Group                            \\
//====================================================================================\\


resource "aws_security_group" "ec2_sg" {
  name        = "${var.ec2_conf.project_name}-sg"
  description = "Allow SSH, HTTP, HTTPS"

  dynamic "ingress" {
    for_each = var.ec2_conf.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//====================================================================================\\
//                                   Creation of EC2                                  \\
//====================================================================================\\

resource "aws_instance" "ec2" {
  ami                    = var.ec2_conf.ami_id
  instance_type          = var.ec2_conf.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = file("${path.root}/scripts/install_docker.sh")

  tags = {
    Name = "${var.ec2_conf.project_name}-ec2"
  }
}
