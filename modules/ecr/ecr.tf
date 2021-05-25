resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.app_name}-ecr"
  image_tag_mutability = "MUTABLE"

}