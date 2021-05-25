resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster-${var.app_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "my-first-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "my-first-task",
      "image": "${aws_ecr_repository.ecr_repo.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}


resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRolea"
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
  name            = "${var.app_name}-service"                         
  cluster         = "${aws_ecs_cluster.cluster.id}"                     
  task_definition = "${aws_ecs_task_definition.task_definition.arn}" 
  launch_type     = "FARGATE"
  desired_count   = var.container_count 
  depends_on      = [aws_ecs_task_definition.task_definition]

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}","${aws_default_subnet.default_subnet_b.id}"]
    security_groups = ["${aws_security_group.service_security_group.id}"]
    assign_public_ip = true 
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.app_name}-ecr"
  image_tag_mutability = "MUTABLE"

}