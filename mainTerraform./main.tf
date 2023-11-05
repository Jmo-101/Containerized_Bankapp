
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}

resource "aws_instance" "d7jenkins" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [var.defaultsg]
  user_data              = "${file("Jdeploy.sh")}"
  key_name = "d7_key"


  tags = {
    "Name" = "d7Jenkins"
  }
}

resource "aws_instance" "d7Docker" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [var.defaultsg]
  user_data              = "${file("DockerDeploy.sh")}"
  key_name = "d7_key"

  tags = {
    "Name" = "d7Docker"
  }
}

resource "aws_instance" "d7tfBank" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [var.defaultsg]
  user_data              = "${file("Tdeploy.sh")}"
  key_name = "d7_key"

  tags = {
    "Name" = "d7tfBank"
  }
}





#outputs new instance IP in the terminal 
output "instance_ip" {
  value = aws_instance.d7jenkins.public_ip
}

output "instance_ip2" {
  value = aws_instance.d7Docker.public_ip
}

output "instance_ip3" {
  value = aws_instance.d7tfBank.public_ip
}
