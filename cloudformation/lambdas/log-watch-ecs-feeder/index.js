const zlib = require('zlib');

exports.handler = async (event) => {
    // TODO implement
    const payload = Buffer.from(event.awslogs.data, 'base64');

    const logevents = JSON.parse(zlib.unzipSync(payload).toString());

    console.log("=================", logevents);

    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
    return response;
};
