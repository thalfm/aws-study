const AWS = require('aws-sdk');


exports.handler = async (event, context) => {
  try {

    const sqs = new AWS.SQS();

    const message = event.Records[0].body;
    const queueUrl = process.env.processOrdersQueueUrl; // substitua pelo URL da sua fila de destino
    const params = {
      MessageBody: message,
      QueueUrl: queueUrl
    };
    await sqs.sendMessage(params).promise();
    console.log(`A mensagem "${message}" foi enviada para a fila SQS.`);

    // Exclui a mensagem da fila de origem
    const deleteParams = {
      QueueUrl: process.env.generatedOrdersQueueUrl, // substitua pelo URL da sua fila de origem
      ReceiptHandle: event.Records[0].receiptHandle
    };
    await sqs.deleteMessage(deleteParams).promise();
    console.log(`A mensagem "${message}" foi excluída da fila SQS de origem.`);
  } catch (err) {
    console.error(err);
  }
};
