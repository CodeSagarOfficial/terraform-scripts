resource "aws_ecs_cluster" "default" {
  name = var.ecs_cluster_name
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/wp-ecs-tf"
  retention_in_days = 7

  tags = {
    Environment = "production"
    Application = "wp"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-tf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wp-ecs-task-tf"
  container_definitions    = data.template_file.wp-container.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "wp-ecs-svc" {
  name            = "wp-ecs-svc-tf"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.default.arn
    container_name   = "wordpress"
    container_port   = 80
  }

  network_configuration {
    subnets          = [aws_subnet.wp-public-a-tf.id, aws_subnet.wp-public-b-tf.id, aws_subnet.wp-public-c-tf.id]
    security_groups  = [aws_security_group.wp-alb-tf.id]
    assign_public_ip = true
  }
}