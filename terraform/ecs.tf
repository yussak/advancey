resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
}

# タスク定義
resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
}

# ecsサービス####################################################################
resource "aws_ecs_service" "test" {
  name                              = "test"
  cluster                           = aws_ecs_cluster.cluster.arn
  task_definition                   = aws_ecs_task_definition.test.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_sg.security_group_id]

    subnets = [
      aws_subnet.private-1a.id,
      aws_subnet.private-1c.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.test.arn
    container_name   = "test"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

module "nginx_sg" {
  source      = "./security_group"
  name        = "nginx-sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  cidr_blocks = [aws_vpc.vpc.cidr_block]
}
