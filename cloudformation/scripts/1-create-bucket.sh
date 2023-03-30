#!/bin/bash
aws --profile=local cloudformation create-stack --stack-name=create-my-bucket --template-body=file://bucket.yaml