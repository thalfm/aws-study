import { LambdaClient, ListEventSourceMappingsCommand, UpdateEventSourceMappingCommand } from '@aws-sdk/client-lambda';

const queueArn = process.env.QUEUE_ARN;
const functionName = process.env.FUNCTION_NAME;

export const handler = async (event) => {
    console.log(event);

    const client = new LambdaClient();

    const command = new ListEventSourceMappingsCommand({
        EventSourceArn: queueArn,
        FunctionName: functionName
    });

    const listResponse = await client.send(command);

    if (listResponse.EventSourceMappings && listResponse.EventSourceMappings.length > 0) {
        const eventSourceMapping = listResponse.EventSourceMappings[0];
        console.log(`Set event source mapping ${eventSourceMapping.UUID} enabled property to ${event.enabled}...`);
        const commandUpdate = new UpdateEventSourceMappingCommand({
            UUID: eventSourceMapping.UUID,
            Enabled: event.enabled
        });

        await client.send(commandUpdate);
        return "ok";
    } else {
        console.log(`No / multiple event source for EventSourceArn ${queueArn} and funcation name ${functionName} found.`);
        return "failed";
    }
}