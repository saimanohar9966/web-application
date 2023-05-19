# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "webapplication-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_web.id]
  subnets            = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
  # subnets = ["subnet-079e90be25cae579f", "subnet-0c541825a8ac63cde" ]
}

# ALB Target Group
resource "aws_lb_target_group" "tg" {
  name     = "webapp-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
  # vpc_id = "vpc-0b2777b23e76ca16b"
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "tga" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}


output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}
