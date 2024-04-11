data "aws_caller_identity" "current" {}

#module "ordens_geradas" {
#    source = "../../infra/ordens-geradas"
#    environment = "${var.environment}"
#    region = "${var.region}"
#    account_id = "${data.aws_caller_identity.current.account_id}"
#}
#
#module "network" {
#    source = "../../infra/network"
#}
#
#module "container" {
#    source = "../../infra/container"
#    vpc_id = module.network.vpc_id
#}
#
#module "erp" {
#    source = "../../infra/erp"
#    repository_url = "${module.container.repository_url}:latest"
#    ecs_task_execution_role = module.container.ecs_task_execution_role_arn
#    lab_security_group = module.container.lab_security_group
#    subnet_private_1 = module.network.subnet_private_1
#    subnet_private_2 = module.network.subnet_private_2
#    region = "${var.region}"
#}


module "recorrencia" {
    source = "../../infra/recorrencia"
    environment = "${var.environment}"
    region = "${var.region}"
    account_id = "${data.aws_caller_identity.current.account_id}"
}

module "circuit_breaker_recorrencia" {
    source = "../../infra/circuit-breaker"
    target_function_name = "consumidor-processamento"
    target_function_arn = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:consumidor-processamento"
    target_queue_name = module.recorrencia.aws_sqs_queue_recorrencia_name
    target_queue_arn = module.recorrencia.aws_sqs_queue_recorrencia_arn
    region = "${var.region}"
    account_id = "${data.aws_caller_identity.current.account_id}"
}