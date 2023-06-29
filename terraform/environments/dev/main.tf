data "aws_caller_identity" "current" {}

module "ordens_geradas" {
    source = "../../infra/ordens-geradas"
    environment = "${var.environment}"
    region = "${var.region}"
    account_id = "${data.aws_caller_identity.current.account_id}"
}

module "network" {
    source = "../../infra/network"
}