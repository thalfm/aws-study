[
    {
        "name": "${container_name}",
        "image": "${container_image}",
        "portMappings": [{
            "containerPort": "${container_port}",
            "hostPort": "${host_port}"
        }],
        "command": ["php","src/console.php","app:send-orders"],
        "logConfiguration": {
            "logDriver": "awsLog",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${var.region}",
                "awslogs-stream-prefix": "lab" 
            }
        }
    }
]