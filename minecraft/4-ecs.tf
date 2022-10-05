resource "random_string" "rand4" {
  length  = 4
  special = false
  upper   = false
}

resource "aws_iam_role" "ECSTaskExecutionRole" {
  name_prefix = var.name_prefix

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Environment = var.tag
  }
}

resource "aws_ecs_cluster" "ecs_fargate" {
  name = "${var.name_prefix}-${random_string.rand4.result}"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.name_prefix}_server"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ECSTaskExecutionRole.arn


  container_definitions = jsonencode(
    [
      {
        "cpu" : var.container_cpu,
        "image" : var.image_url,
        "memory" : var.container_memory,
        "name" : var.name_prefix
        "portMappings" : [
          {
            "containerPort" : var.minecraft_port,
          }
        ]
      }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  depends_on                         = [aws_lb.public]
  name                               = "${var.name_prefix}-${random_string.rand4.result}"
  cluster                            = aws_ecs_cluster.ecs_fargate.id
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "75"
  desired_count                      = var.desired_count
  network_configuration {
    subnets         = data.aws_subnets.private.ids
    security_groups = [aws_security_group.minecraft_sg.id]
  }
  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.ecs_task.family}:${max(aws_ecs_task_definition.ecs_task.revision, aws_ecs_task_definition.ecs_task.revision)}"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group_public.arn
    container_name   = var.name_prefix
    container_port   = var.minecraft_port
  }
}
