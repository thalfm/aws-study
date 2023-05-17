#!/bin/bash

# create bucket
aws --profile=cloudguru cloudformation create-stack --stack-name=create-my-bucket --template-body=file://bucket.yaml

# create sns sqs
aws --profile=cloudguru cloudformation create-stack --stack-name=create-ordens-geradas-sns --template-body=file://sns-sqs-ordens-geradas.yaml

# create lambda gerar ordem-pagamento
cd lambdas/gerador-ordem-pagamento
rm -v gerador-ordem-pagamento.zip
zip gerador-ordem-pagamento.zip index.js
aws --profile=cloudguru s3 cp gerador-ordem-pagamento.zip s3://otp-lambdas/gerador-ordem-pagamento.zip
cd ../../

# 4 create lambda gerar ordem-pagamento
aws --profile=cloudguru cloudformation create-stack --stack-name=gerar-ordem-pagamento-lambda --template-body=file://lambda-gerador-ordem-pagamento.yaml --capabilities=CAPABILITY_NAMED_IAM

# 5 create fila-ordens processadas
aws --profile=cloudguru cloudformation create-stack --stack-name=criar-ordens-processadas-queue --template-body=file://sqs-ordens-processadas.yaml

# 6 create lambda acionar tarefa ecs deploy
cd lambdas/acionar-tarefa-ecs
rm -v acionar-tarefa-ecs.zip
zip acionar-tarefa-ecs.zip index.js
aws --profile=cloudguru s3 cp acionar-tarefa-ecs.zip s3://otp-lambdas/acionar-tarefa-ecs.zip
cd ../../

# 7-criar-lambda-enviar-ordem-pagamento.sh
aws --profile=cloudguru cloudformation create-stack --stack-name=acionar-tarefa-ecs-lambda --template-body=file://acionar-tarefa-ecs.yaml --capabilities=CAPABILITY_NAMED_IAM

# 8-lambda-confirmar-envio-ordem-pagamento-deploy.sh
cd lambdas/confirmar-envio-ordem-pagamento
rm -v confirmar-envio-ordem-pagamento.zip
zip confirmar-envio-ordem-pagamento.zip index.js
aws --profile=cloudguru s3 cp confirmar-envio-ordem-pagamento.zip s3://otp-lambdas/confirmar-envio-ordem-pagamento.zip
cd ../../

# 9 -criar-lambda-confirmar-envio-ordem-pagamento.sh
aws --profile=cloudguru cloudformation create-stack --stack-name=confirmar-envio-ordem-pagamento-lambda --template-body=file://lambda-confirmar-envio-ordem-pagamento.yaml --capabilities=CAPABILITY_NAMED_IAM

# 10 - criar o ecr
aws --profile=cloudguru cloudformation create-stack --stack-name=criar-ecr --template-body=file://ecr.yaml --parameters=ParameterKey=RepositoryName,ParameterValue=app-send-orders

# 11 - criar a vpc
aws --profile=cloudguru cloudformation create-stack --stack-name=criar-vpc --template-body=file://vpc-three-tier.yaml

# 12 - criar o cluster
aws --profile=cloudguru cloudformation create-stack --stack-name=criar-ecs-cluster --template-body=file://ecs-cluster.yaml --parameters=ParameterKey=RepositoryName,ParameterValue=app-send-orders






