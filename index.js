const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {

    const predictionID = `pred-$(Date.now())`;
    const { question, prediction } = event;

    const params = {
      TableName: process.env.DYNAMODB_TABLE,
      Item: {
        predictionID,
        question,
        prediction
      }
    };

    try {
      await dynamodb.put(params).promise();
      return {
        statusCode: 200,
        body: JSON.stringify({ message: "Prediction saved successfully", predictionID })
      };
    } catch (error) {
        return {
          statusCode: 500,
          body: JSON.stringify({ message: "Error saving prediction", error })
        }; 
    }
};