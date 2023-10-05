module.exports.handler = async (event) => {
  return {
    statusCode: 500,
    body: JSON.stringify(
      {
        message: 'Error',
        input: event,
      },
      null,
      2
    ),
  };
};
