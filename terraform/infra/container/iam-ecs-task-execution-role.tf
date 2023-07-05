data "aws_iam_policy_document" "assume_role_policy" {}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

output "ecs_task_execution_role_arn" {
    value = "${aws_iam_role.ecs_task_execution_role.arn}"
}