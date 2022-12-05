# roles de IAM
# Creamos un nuevo rol de IAM llamado ecs_role_example_app
# Vinculado a AmazonECSTaskExecutionRolePolicy
resource "aws_iam_role" "ecs_role" {
  name = "ecs_role_example_app"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role = "${aws_iam_role.ecs_role.name}"

  # Esta politica añade permisos de logging y ECR
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}