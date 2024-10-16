const AWS = require('aws-sdk');
const OpenAI = require('openai');

// Initialize OpenAI with the API key from environment variables
const openai = new OpenAI({ apiKey: process.env.API_KEY });

// Initialize DynamoDB
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async function (event) {
    const tableName = process.env.DYNAMODB_TABLE;

    // Parse the incoming request body
    let body;
    try {
        body = JSON.parse(event.body);
    } catch (error) {
        return {
            statusCode: 400,
            body: JSON.stringify({ message: "Invalid request body" })
        };
    }

    // Validate that 'question' is provided
    if (!body.question || typeof body.question !== 'string') {
        return {
            statusCode: 400,
            body: JSON.stringify({ message: "'question' field is required and must be a string" })
        };
    }

    const question = body.question;
    const predictionId = `pred-${Date.now()}`;

    try {
        // Call OpenAI API to generate a humorous prediction in German
        const completion = await openai.chat.completions.create({
            model: "gpt-3.5-turbo",
            messages: [
                { role: "system", content: "You are a helpful assistant." },
                { role: "user", content: `Generiere eine Zukunftsvorhersage basierend auf der Frage: "${question}". Antworte auf die Frage in einer überraschenden, non-konventionellen Art, mit tollem und exquisitem Humor, nicht mehr als 240 Zeichen, auf Deutsch, im lockeren und freundlichen Stil.` }
            ],
            max_tokens: 60,
            temperature: 0.7
        });

        // Extract the prediction from the OpenAI response
        const prediction = completion.choices[0].message.content.trim();

        // Store the question and prediction in DynamoDB
        const params = {
            TableName: tableName,
            Item: {
                predictionId,
                question,
                prediction
            }
        };

        await dynamodb.put(params).promise();

        // Return success response
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: "Prediction generated and stored successfully",
                predictionId,
                question,
                prediction
            })
        };

    } catch (error) {
        console.error("Error generating or storing prediction:", error);

        // Handle error response from OpenAI or DynamoDB
        return {
            statusCode: 500,
            body: JSON.stringify({
                message: "Error generating prediction or storing in DynamoDB",
                error: error.message || error
            })
        };
    }
};
