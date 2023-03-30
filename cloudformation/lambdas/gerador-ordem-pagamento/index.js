const AWS = require('aws-sdk');

exports.handler = async (event) => {
  const sns = new AWS.SNS();
  const params = {
    Message: JSON.stringify(event),
    TopicArn: 'arn:aws:sns:us-east-1:548633167931:OrdensGeradasTopic' // Substitua TOPIC_ARN pelo ARN do tópico do Amazon SNS
  };

  try {
    await sns.publish(params).promise();
    console.log(`Mensagem publicada no tópico ${params.TopicArn}`);
  } catch (err) {
    console.error(err);
  }
};
