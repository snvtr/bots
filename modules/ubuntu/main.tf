# keys to access the instance:
resource "aws_key_pair" "ubuntu_key" {
  key_name   = "ubuntu-key"
  public_key = file("keys/id_rsa.pub")
}

# the instance:
resource "aws_instance" "ubuntu" {

  ami           = "ami-053b0d53c279acc90" # Ubuntu 22.04
  instance_type = "t3a.nano"

  key_name      = aws_key_pair.ubuntu_key.key_name

  vpc_security_group_ids = [
    aws_security_group.ubuntu_vpc.id
  ]

  #user_data = file("scripts/first-boot.sh")

  # connection info:
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("keys/id_rsa")
    host        = aws_instance.ubuntu.public_ip
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook -u ubuntu --private-key=~/.ssh/id_rsa -i '${aws_instance.ubuntu.private_ip}' files/do_all.yml"
}

# files needed to complete install:
  provisioner "file" {
    source      = "files/antispam-bot.env"
    destination = "/tmp/antispam-bot.env"
  }

  provisioner "file" {
    source      = "files/egenix_telegram_antispam_bot-0.4.0-py3-none-any.whl"
    destination = "/tmp/egenix_telegram_antispam_bot-0.4.0-py3-none-any.whl"
  }

  provisioner "file" {
    source      = "files/kaztili-bot.env"
    destination = "/tmp/kaztili-bot.env"
  }

  provisioner "file" {
    source      = "files/runcalc-bot.env"
    destination = "/tmp/runcalc-bot.env"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod 0755 /tmp/do_all.sh",
      "/tmp/do_all.sh"
    ]
  }

  tags = {
    Name = "ubuntu-instance"
  }
}

resource "aws_security_group" "ubuntu_vpc" {

  name = "ubuntu_vpc"

  # Open ssh port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open access to public network
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ubuntu-vpc"
  }
}

