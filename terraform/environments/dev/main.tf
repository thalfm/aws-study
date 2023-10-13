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

module "circuit-breaker" {
    source = "../../infra/circuit-breaker"
}

module "recorrencia" {
    source = "../../infra/recorrencia"
    environment = "${var.environment}"
    region = "${var.region}"
    account_id = "${data.aws_caller_identity.current.account_id}"
}