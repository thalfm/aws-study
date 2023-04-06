const AWS = require('aws-sdk');
const sts = new AWS.STS();

exports.handler = async (event) => {
  const sns = new AWS.SNS();

  const data = await sts.getCallerIdentity().promise();

  const accountId = data.Account;
  const region = process.env.AWS_REGION;

  const params = {
    Message: JSON.stringify(event),
    TopicArn: 'arn:aws:sns:' + region + ':' + accountId + ':OrdensGeradasTopic' // Substitua TOPIC_ARN pelo ARN do tópico do Amazon SNS
  };

  try {
    await sns.publish(params).promise();
    console.log(`Mensagem publicada no tópico ${params.TopicArn}`);
  } catch (err) {
    console.error(err);
  }
};
