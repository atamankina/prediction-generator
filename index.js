const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {

    const predictionId = `pred-$(Date.now())`;
    const { question, prediction } = event;

    const params = {
      TableName: process.env.DYNAMODB_TABLE,
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
        body: JSON.stringify({ message: "Prediction saved successfully", predictionId })
      };
    } catch (error) {
        return {
          statusCode: 500,
          body: JSON.stringify({ message: "Error saving prediction", error })
        }; 
    }
};