const AWS = require('aws-sdk');


exports.handler = async (event, context) => {
  try {

    const sqs = new AWS.SQS();

    const message = event.Records[0].body;

    // enviar para o bucket
    console.log(`A mensagem "${message}" foi enviada para o bucket.`);

    // Exclui a mensagem da fila de origem
    const deleteParams = {
      QueueUrl: process.env.processOrdersQueueUrl, // substitua pelo URL da sua fila de origem
      ReceiptHandle: event.Records[0].receiptHandle
    };
    await sqs.deleteMessage(deleteParams).promise();
    console.log(`A mensagem "${message}" foi excluída da fila SQS de origem.`);
  } catch (err) {
    console.error(err);
  }
};
