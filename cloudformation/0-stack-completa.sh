#!/bin/bash


# 1 - criar o ecr
aws --profile=cloudguru cloudformation create-stack --stack-name=criar-ecr --template-body=file://ecr.yaml --parameters=ParameterKey=RepositoryName,ParameterValue=app-send-orders

# 2 - criar a vpc
aws --profile=cloudguru cloudformation create-stack --stack-name=criar-vpc --template-body=file://vpc-three-tier.yaml

# 3 - criar o cluster
aws --profile=cloudguru cloudformation create-stack --stack-name=criar-ecs-cluster --template-body=file://ecs-cluster.yaml --parameters=ParameterKey=RepositoryName,ParameterValue=app-send-orders

# 4 create bucket
aws --profile=cloudguru cloudformation create-stack --stack-name=create-my-bucket --template-body=file://bucket.yaml

# 5 create sns sqs
aws --profile=cloudguru cloudformation create-stack --stack-name=create-ordens-geradas-sns --template-body=file://sns-sqs-ordens-geradas.yaml

# 6 create lambda gerar ordem-pagamento
cd lambdas/gerador-ordem-pagamento &&
zip gerador-ordem-pagamento.zip index.js &&
aws --profile=cloudguru s3 cp gerador-ordem-pagamento.zip s3://otp-lambdas/gerador-ordem-pagamento.zip &&
cd ../../

# 5 create lambda gerar ordem-pagamento
aws --profile=cloudguru cloudformation create-stack --stack-name=gerar-ordem-pagamento-lambda --template-body=file://lambda-gerador-ordem-pagamento.yaml --capabilities=CAPABILITY_NAMED_IAM

# 6 create fila-ordens processadas
aws --profile=cloudguru cloudformation create-stack --stack-name=criar-ordens-processadas-queue --template-body=file://sqs-ordens-processadas.yaml

# 7 create lambda acionar tarefa ecs deploy
cd lambdas/acionar-tarefa-ecs &&
zip acionar-tarefa-ecs.zip index.js && 
aws --profile=cloudguru s3 cp acionar-tarefa-ecs.zip s3://otp-lambdas/acionar-tarefa-ecs.zip &&
cd ../../

export ecs_cluster_name="my-cluster-name" &&
export ecs_task_definition="my-task-family:2" &&
export ecs_task_subnets=subnet-0cc3bd8ce28b892f2 &&
export ecs_security_groups='sg-014b70627780d0be4'
# 9 criar-lambda-enviar-ordem-pagamento.sh
aws --profile=cloudguru cloudformation create-stack --stack-name=acionar-tarefa-ecs-lambda --template-body=file://acionar-tarefa-ecs.yaml --capabilities=CAPABILITY_NAMED_IAM --parameters ParameterKey=ecsClusterName,ParameterValue="$ecs_cluster_name" \
                 ParameterKey=ecsTaskDefinition,ParameterValue="$ecs_task_definition" \
                 ParameterKey=ecsTaskSubnets,ParameterValue="$ecs_task_subnets" \
                 ParameterKey=ecsSecurityGroups,ParameterValue="$ecs_security_groups"


# 10 lambda-confirmar-envio-ordem-pagamento-deploy.sh
cd lambdas/confirmar-envio-ordem-pagamento &&
zip confirmar-envio-ordem-pagamento.zip index.js &&
aws --profile=cloudguru s3 cp confirmar-envio-ordem-pagamento.zip s3://otp-lambdas/confirmar-envio-ordem-pagamento.zip && 
cd ../../

# 11 criar-lambda-confirmar-envio-ordem-pagamento.sh
aws --profile=cloudguru cloudformation create-stack --stack-name=confirmar-envio-ordem-pagamento-lambda --template-body=file://lambda-confirmar-envio-ordem-pagamento.yaml --capabilities=CAPABILITY_NAMED_IAM

# 12 criar-lambda-confirmar-envio-ordem-pagamento.sh
aws --profile=cloudguru lambda add-permission \
    --function-name "my-log-watch-sns-feeder" \
    --statement-id "my-log-watch-sns-feeder" \
    --principal "logs.amazonaws.com" \
    --action "lambda:InvokeFunction" \
    --source-arn "arn:aws:logs:us-east-1:744176206000:log-group:/ecs/my-task-family:*" \
    --source-account "744176206000"


# 13 criar-lambda-confirmar-envio-ordem-pagamento.sh
aws --profile=cloudguru  logs put-subscription-filter 
--log-group-name /aws/ecs/mycontainer 
--destination-arn arn:aws:lambda:us-east-1:744176206000:function:my-log-watch-sns-feeder
--filter-name container-errors --filter-pattern "ERROR"
