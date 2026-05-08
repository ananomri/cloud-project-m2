resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]
  key_name = var.existing_key_name
  user_data = base64encode(templatefile("${path.module}/user_data_frontend.sh", {
    alb_dns = aws_lb.main.dns_name
  }))

  tags = {
    Name = "${var.project_name}-frontend"
  }
}
