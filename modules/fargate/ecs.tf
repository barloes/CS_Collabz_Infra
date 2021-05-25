resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster-${var.app_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "template_file" "json_template" {
  template = file("${path.module}/template.json")
  vars = {
    app_name = var.app_name
    app_image = "642151248908.dkr.ecr.ap-southeast-1.amazonaws.com/junecr-ecr:latest"
    app_port = var.container_port
    fargate_cpu = var.container_cpu
    fargate_memory = var.container_memory
    aws_region = var.aws_region
  }
}


resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.app_name
  container_definitions = data.template_file.json_template.rendered

  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.container_memory         # Specifying the memory our container requires
  cpu                      = var.container_cpu        # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
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
  depends_on      = [aws_ecs_task_definition.task_definition,aws_ecs_cluster.cluster]

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}","${aws_default_subnet.default_subnet_b.id}"]
    assign_public_ip = true 
  }

  ordered_placement_strategy {
    type  = var.ordered_placement_type
    field = var.ordered_placement_field
  }
}
