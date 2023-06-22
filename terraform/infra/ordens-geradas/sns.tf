resource "aws_sns_topic" "ordens_geradas" {
    name = "${var.environment}-ordens-geradas"
    tags = {
        "SERVICE" = "OTP",
        "SQUAD" = "OTP",
        "BU" = "Backoffice"
    }
}

output "ordens_geradas_topic_arn" {
    value = "${aws_sns_topic.ordens_geradas.arn}"
}