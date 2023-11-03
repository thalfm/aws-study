import { SQSClient, ReceiveMessageCommand, DeleteMessageCommand } from '@aws-sdk/client-sqs';
import { LambdaClient, InvokeCommand } from '@aws-sdk/client-lambda';

const sqsClient = new SQSClient({ region: 'us-east-1' }); // Substitua 'us-east-1' pela sua região
const lambdaClient = new LambdaClient({ region: 'us-east-1' }); // Substitua 'us-east-1' pela sua região

const queueName = process.env.QUEUE_NAME;
const functionName = process.env.FUNCTION_NAME;

export const handler = async () => {
    console.log(`Resolve URL of queue with name ${queueName}...`);
    const queueUrlResult = await sqsClient.send(new ReceiveMessageCommand({ QueueUrl: queueName, AttributeNames: ["All"] }));

    const queueUrl = queueUrlResult.QueueUrl;

    console.log(`Poll queue ${queueUrl} for message...`);

    if(queueUrlResult.Messages && queueUrlResult.Messages.length > 0) {
        console.log(`Message received. Invoking lambda function ${functionName} with SQS event...`);
        const sqsMessage = queueUrlResult.Messages[0];
        const sqsEvent = { Records: [{
                messageId: sqsMessage.MessageId,
                receiptHandle: sqsMessage.ReceiptHandle,
                body: sqsMessage.Body,
                md5OfBody: sqsMessage.MD5OfBody,
                attributes: sqsMessage.Attributes,
                messageAttributes: sqsMessage.MessageAttributes || {},
                eventSource: "aws:sqs",
                queueArn: sqsMessage.Attributes.QueueArn
            }]};
        try {
            const lambdaInvokeResult = await lambdaClient.send(new InvokeCommand({ FunctionName: functionName, Payload: JSON.stringify(sqsEvent) }));

            console.log("Invocation result: " + JSON.stringify(lambdaInvokeResult));

            if (lambdaInvokeResult.FunctionError) {
                console.log("Invocation with function error.");
                return "failed";
            }

            console.log("Invocation succeeded.");
        } catch (e) {
            console.log("Invocation failed: " + JSON.stringify(e));
            return "failed";
        }

        console.log(`Deleting message ${sqsMessage.MessageId} from queue...`);
        const deleteMessageResult = await sqsClient.send(new DeleteMessageCommand({ QueueUrl: queueUrl, ReceiptHandle: sqsMessage.ReceiptHandle }));

        console.log("Message deleted. Result: " + JSON.stringify(deleteMessageResult));

        return "passed";
    } else {
        console.log("No messages available.");
        return "no-message-available";
    }
}