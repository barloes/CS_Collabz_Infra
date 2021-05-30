resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.test_role.name}"
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.test_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


### IAM Role and Policy ###
# Allows Lambda function to describe, stop and start EC2 instances
resource "aws_iam_role" "ec2_start_stop_scheduler" {
  name = "ec2_start_stop_scheduler"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "ec2_start_stop_scheduler" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

  statement {
    actions = [
      "ec2:Describe*",
      "ec2:Stop*",
      "ec2:Start*"
    ]
    resources = [
        "*",
    ]
  }
}

resource "aws_iam_policy" "ec2_start_stop_scheduler" {
  name = "ec2_access_scheduler"
  path = "/"
  policy = "${data.aws_iam_policy_document.ec2_start_stop_scheduler.json}"
}

resource "aws_iam_role_policy_attachment" "ec2_access_scheduler" {
  role       = "${aws_iam_role.ec2_start_stop_scheduler.name}"
  policy_arn = "${aws_iam_policy.ec2_start_stop_scheduler.arn}"
}