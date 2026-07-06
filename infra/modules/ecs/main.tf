####################################
# CloudWatch Log Group
####################################

resource "aws_cloudwatch_log_group" "ecs" {

  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = 7

}

####################################
# ECS Cluster
####################################

resource "aws_ecs_cluster" "this" {

  name = "${var.project_name}-${var.environment}-cluster"

}

####################################
# IAM Role
####################################

resource "aws_iam_role" "ecs_execution_role" {

  name = "${var.project_name}-${var.environment}-ecs-execution-role"

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

resource "aws_iam_role_policy_attachment" "ecs_execution_role" {

  role       = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

####################################
# ECS Security Group
####################################

resource "aws_security_group" "ecs" {

  name   = "${var.project_name}-${var.environment}-ecs-sg"

  vpc_id = var.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [

      var.alb_security_group_id

    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [

      "0.0.0.0/0"

    ]

  }

}

####################################
# Task Definition
####################################

resource "aws_ecs_task_definition" "this" {

  family = "${var.project_name}-${var.environment}"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu = "256"

  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([

    {

      name = "nginx"

      image = "nginx:latest"

      essential = true

      portMappings = [

        {

          containerPort = 80

          hostPort = 80

          protocol = "tcp"

        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.ecs.name

          awslogs-region = "us-east-1"

          awslogs-stream-prefix = "ecs"

        }

      }

    }

  ])

}

####################################
# ECS Service
####################################

resource "aws_ecs_service" "this" {

  name = "${var.project_name}-${var.environment}-service"

  cluster = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.this.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.private_subnet_ids

    security_groups = [

      aws_security_group.ecs.id

    ]

    assign_public_ip = false

  }

  load_balancer {

    target_group_arn = var.target_group_arn

    container_name = "nginx"

    container_port = 80

  }

  depends_on = [

    aws_iam_role_policy_attachment.ecs_execution_role

  ]

}