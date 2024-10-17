const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async () => {
    const tableName = process.env.DYNAMODB_TABLE;

    console.log("Starting Lambda function execution");
    console.log(`Using DynamoDB table: ${tableName}`);

    const params = {
        TableName: tableName
    };

    try {
        console.log("Scanning DynamoDB table...");
        const data = await dynamodb.scan(params).promise();
        console.log("Scan successful. Data received:", JSON.stringify(data.Items));

        return {
            statusCode: 200,
            headers: {
                "Access-Control-Allow-Origin": "*",  // Allow all origins or specify your frontend origin
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
            },
            body: JSON.stringify(data.Items)
        };
    } catch (error) {
        console.error("Error during DynamoDB scan:", error);

        return {
            statusCode: 500,
            headers: {
                "Access-Control-Allow-Origin": "*",  // Allow all origins or specify your frontend origin
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
            },
            body: JSON.stringify({ message: "Error fetching predictions", error: error.message })
        };
    }
};