resource "aws_ecs_task_definition" "erp_task_service" {
   family = "erp_task_service"
   network_mode = "awsvpc"
   requires_compatibilities = ["FARGATE"]
}