resource "aws_key_pair" "instance_key" {
  key_name   = "instance-key"
  public_key = file("keys/id_rsa.pub")
}

resource "aws_instance" "instance" {
 
  ami           = "ami-053b0d53c279acc90" # Ubuntu 22.04
  instance_type = "t3.nano"

  key_name      = aws_key_pair.instance_key.key_name

  vpc_security_group_ids = [
    aws_security_group.instance_vpc.id
  ]
  
  #user_data = file("scripts/first-boot.sh")

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("keys/id_rsa")
    host        = aws_instance.instance.public_ip
  }

  provisioner "file" {
    source      = "files/do_all.sh"
    destination = "/tmp/do_all.sh"
  }

  provisioner "file" {
    source      = "files/user.env"
    destination = "/tmp/"
  }


  provisioner "file" {
    source      = "files/antispam-bot.env"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "files/egenix_telegram_antispam_bot-0.4.0-py3-none-any.whl"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "files/kaztili-bot.env"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "files/runcalc-bot.env"
    destination = "/tmp/"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod 0755 /tmp/do_all.sh",
      "/tmp/do_all.sh"
    ]
  }

  tags = {
    Name = "instance-instance"
  }
}

resource "aws_security_group" "instance_vpc" {

  name = "instance_vpc"

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

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("keys/id_rsa")
    host        = aws_instance.instance.public_ip
  }

  tags = {
    Name = "instance-vpc"
  }
}

