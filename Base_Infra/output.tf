output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_1a_id" {
  value = aws_subnet.public-subnet-1a.id
}

output "public_subnet_1b_id" {
  value = aws_subnet.public-subnet-1b.id
}


output "public_subnets" {
  value = tolist([aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1b.id])
}


output "ecs_cluster_role_name" {
  value = aws_iam_role.ecs-cluster-role.name
}

output "ecs_cluster_role_arn" {
  value = aws_iam_role.ecs-cluster-role.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}


output "ecs-sg-id" {
  value = aws_security_group.ecs-sg.id
}
