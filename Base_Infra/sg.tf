resource "aws_security_group" "ecs-sg" {
  name        = "ECS Security Group"
  description = "Allow Traffic to ECS Cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 0  
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
      }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}