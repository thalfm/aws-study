const AWS = require('aws-sdk');

const ecs = new AWS.ECS();

const environment = {
    taskconfiguration: {
        cluster: env.get('ECS_CLUSTER_NAME').required().asString(),
        launchType: 'FARGATE',
        count: 1,
        taskDefinition: env.get('ECS_TASK_DEFINITION').required().asString(),
        platformVersion: 'LATEST',
    },
    containerConfiguration: {
        name: 'integracao-erp'
    },
    network: {
        subnets: env.get('ECS_TASK_SUBNETS').required().asArray(),
        securityGroups: env.get('ECS_SECURITY_GROUPS').required().asArray(),
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
                            name: 'AWS_ACCESS_KEY',
                            value: env.get('AWS_ACCESS_KEY').required().asString(),
                        },
                        {
                            name: 'AWS_SECRET_KEY',
                            value: env.get('AWS_SECRET_KEY').required().asString(),
                        },
                        {
                            name: 'AWS_SQS_URL_ORDERS_SEND',
                            value: env.get('AWS_SQS_URL_ORDERS_SEND').required().asString(),
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
