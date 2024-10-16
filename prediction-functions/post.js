const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    const tableName = process.env.DYNAMODB_TABLE;
    const { question, prediction } = JSON.parse(event.body);
    const predictionId = `pred-${Date.now()}`;

    const params = {
        TableName: tableName,
        Item: {
            predictionId,
            question,
            prediction
        }
    };

    try {
        await dynamodb.put(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify({ message: "Prediction created successfully", predictionId })
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Error creating prediction", error })
        };
    }
};
