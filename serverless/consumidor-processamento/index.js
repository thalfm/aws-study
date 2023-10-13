module.exports.handler = async (event) => {

    console.log({ event })

    throw new Error("failed");
};
