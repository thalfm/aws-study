resource "aws_ecs_task_definition" "erp_task_service" {
   family = "erp_task_service"
   network_mode = "awsvpc"
   requires_compatibilities = ["FARGATE"]
   container_definitions = templatefile("${path.module}/templates/container-definition.tpl", {
      container_name = "erp",
      container_image = "${var.repository_url}",
      container_port = 80,
      host_port = 80,
      log_group = "log-group",
      region = "${var.region}"
   })
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_execution_role
}