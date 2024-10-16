const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    const tableName = process.env.DYNAMODB_TABLE;
    const predictionId = event.pathParameters.predictionId;

    const params = {
        TableName: tableName,
        Key: {
            predictionId
        }
    };

    try {
        await dynamodb.delete(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify({ message: "Prediction deleted successfully", predictionId })
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Error deleting prediction", error })
        };
    }
};
