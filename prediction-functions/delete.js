const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    const tableName = process.env.DYNAMODB_TABLE;
    const predictionId = event.pathParameters.predictionId;

    console.log("Received event:", JSON.stringify(event, null, 2));
    console.log(`Deleting prediction with ID: ${predictionId} from table: ${tableName}`);

    const params = {
        TableName: tableName,
        Key: {
            predictionId
        }
    };

    try {
        console.log("Initiating delete operation for predictionId:", predictionId);
        await dynamodb.delete(params).promise();
        console.log(`Prediction with ID: ${predictionId} deleted successfully`);

        return {
            statusCode: 200,
            body: JSON.stringify({ message: "Prediction deleted successfully", predictionId })
        };
    } catch (error) {
        console.error("Error deleting prediction with ID:", predictionId, "Error:", error);

        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Error deleting prediction", error: error.message })
        };
    }
};
