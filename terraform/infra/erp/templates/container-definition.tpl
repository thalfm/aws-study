[
    {
        "name": "${container_name}",
        "image": "${container_image}",
        "memory": 128,
        "cpu": 10,
        "portMappings": [{
            "containerPort": ${container_port},
            "hostPort": ${host_port}
        }],
        "command": ["php","src/console.php","app:send-orders"],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "lab" 
            }
        }
    }
]