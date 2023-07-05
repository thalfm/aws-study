resource "aws_ecs_cluster" "main" {
    name = "ecs_lab"
    tags = {
        Name = "ecs_lab"
    }
}


resource "aws_ecs_cluster_capacity_providers" "ecs_capacity" {
    cluster_name = aws_ecs_cluster.main.name

    capacity_providers = ["FARGATE"]

    default_capacity_provider_strategy {
        base                = 1
        weight              = 100
        capacity_provider   = "FARGATE"
    } 
}