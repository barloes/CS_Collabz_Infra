resource "aws_ecs_cluster" "cluster" {
  name = "${var.app_name}"

}

resource "aws_cloudwatch_log_group" "yada" {
  name = "Yada"

}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.app_name}" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.app_name}",
      "image": "${aws_ecr_repository.ecr_repo.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port}
        }
      ],
      "memory": ${var.container_memory},
      "cpu": ${var.container_cpu},
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.yada.name}",
            "awslogs-region": "ap-southeast-1",
            "awslogs-stream-prefix": "ecs"
          }
        }
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.container_memory        # Specifying the memory our container requires
  cpu                      = var.container_cpu         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}


resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole1"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_service" "service" {
  name            = "${var.app_name}"                         
  cluster         = "${aws_ecs_cluster.cluster.id}"                     
  task_definition = "${aws_ecs_task_definition.task_definition.arn}" 
  launch_type     = "FARGATE"
  desired_count   = var.container_count 
  depends_on      = [aws_ecs_task_definition.task_definition]

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}"]
    security_groups = ["${aws_security_group.service_security_group.id}"]
    assign_public_ip = true 
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.app_name}"
  image_tag_mutability = "MUTABLE"

}