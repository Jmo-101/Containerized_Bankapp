#Traget Group
resource "aws_lb_target_group" "bank-app" {
  name        = "url-app"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.bank_app]
}

#Application Load Balancer
resource "aws_alb" "bank_app" {
  name               = "url-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]

  security_groups = [
    aws_security_group.http.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "bank_app_listener" {
  load_balancer_arn = aws_alb.bank_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bank-app.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.bank_app.dns_name}"
}
