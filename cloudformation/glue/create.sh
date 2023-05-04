#!/bin/bash

TABLE_NAME=my_table
CRAWLER_NAME=$TABLE_NAME-crawler
STACK_NAME=$(echo $CRAWLER_NAME | sed 's/_/-/g')

aws --profile=br-prod cloudformation create-stack --stack-name $STACK_NAME --template-body file://crawler.yaml --parameters ParameterKey=CrawlerName,ParameterValue=$CRAWLER_NAME \
ParameterKey=TableName,ParameterValue=$TABLE_NAME