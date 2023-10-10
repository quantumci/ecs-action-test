# Create an ECS cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

# Create an ECS task definition

resource "aws_ecs_task_definition" "my_task" {

  family                   = "my-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.terraform_remote_state.baseinfra.outputs.ecs_task_execution_role_arn # Replace with your IAM role ARN


  container_definitions = jsonencode([
    {
      name  = "my-container"
      image = "nginx:latest" # Replace with your container image
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "microservices" {

  name            = "my-service"
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 2
  cluster         = aws_ecs_cluster.my_cluster.id
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = flatten([data.terraform_remote_state.baseinfra.outputs.public_subnets])
    security_groups  = [data.terraform_remote_state.baseinfra.outputs.ecs-sg-id]
    assign_public_ip = true
  }
}