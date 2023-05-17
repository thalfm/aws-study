const AWS = require('aws-sdk');

const ecs = new AWS.ECS();

const environment = {
  taskconfiguration: {
    cluster: env.get('ECS_CLUSTER_NAME').required().asString(),
    launchType: env.get('ECS_TASK_LAUNCH_TYPE').required().asString(),
    count: env.get('ECS_TASK_COUNT').required().asString(),
    taskDefinition: env.get('ECS_TASK_DEFINITION').required().asString(),
    platformVersion: env.get('ECS_TASK_PLATFORM_VERSION').required().asString(),
  },
  containerConfiguration: {
    name: env.get('ECS_TASK_CONTAINER_NAME').required().asString(),
    fileEnvName: env.get('ECS_TASK_CONTAINER_FILE_ENV_NAME').required().asString(),
  },
  network: {
    subnets: env.get('ECS_TASK_SUBNETS').required().asArray(),
    securityGroups: env.get('ECS_SECURITY_GROUPS').required().asArray(),
    assignPublicIp: env.get('ECS_TASK_ASSIGN_PUBLIC_IP').required().asString(),
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
              name: environment.containerConfiguration.fileEnvName,
              value: data
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

    const params = {
      MessageBody: message,
      QueueUrl: queueUrl
    };

    console.log("scheduling with sqs data...", JSON.stringify(params))

    const result = await scheduleEcs(JSON.stringify(params), environment)

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
