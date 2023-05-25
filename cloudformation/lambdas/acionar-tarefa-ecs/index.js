const AWS = require('aws-sdk');

const ecs = new AWS.ECS();

const environment = {
    taskconfiguration: {
        cluster: process.env.ECS_CLUSTER_NAME,
        launchType: 'FARGATE',
        count: 1,
        taskDefinition: process.env.ECS_TASK_DEFINITION,
        platformVersion: 'LATEST',
    },
    containerConfiguration: {
        name: 'integracao-erp'
    },
    network: {
        subnets: process.env.ECS_TASK_SUBNETS.split(","),
        securityGroups: process.env.ECS_SECURITY_GROUPS.split(","),
        assignPublicIp: "ENABLED",
    }
}

const scheduleEcs = async (data, environment) => {
    return ecs.runTask({
        ...environment.taskconfiguration,
        overrides: {
            containerOverrides: [
                {
                    name: environment.containerConfiguration.name,
                    environment: [
                        {
                            name: 'ORDERS_CREATED',
                            value: data
                        },
                        {
                            name: 'AWS_SQS_URL_ORDERS_SEND',
                            value: process.env.AWS_SQS_URL_ORDERS_SEND,
                        }
                    ]
                }
            ],
        },
        networkConfiguration: {
            awsvpcConfiguration: {
                ...environment.network
            }
        }
    }).promise()
}

exports.handler = async (event, context) => {

    const message = event.Records[0].body;

    const params = JSON.stringify(message);

    console.log("scheduling with sqs data...", params)

    const result = await scheduleEcs(params, environment)

    console.log("result", result);

    return {
        statusCode: 200,
        body: JSON.stringify(
            {
                result
            },
            null,
            2
        )
    };
};
