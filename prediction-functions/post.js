const AWS = require('aws-sdk');
const OpenAI = require('openai');

// Initialize OpenAI with the API key from environment variables
const openai = new OpenAI({ apiKey: process.env.API_KEY });

// Initialize DynamoDB
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async function (event) {
    const tableName = process.env.DYNAMODB_TABLE;
    
    console.log("Event received:", JSON.stringify(event, null, 2));

    // Parse the incoming request body
    let body;
    try {
        body = JSON.parse(event.body);
        console.log("Parsed request body:", body);
    } catch (error) {
        console.error("Failed to parse request body:", error);
        return {
            statusCode: 400,
            headers: {
                "Access-Control-Allow-Origin": "*",  // Allow all origins or specify your frontend origin
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
            },
            body: JSON.stringify({ message: "Invalid request body" })
        };
    }

    // Validate that 'question' is provided
    if (!body.question || typeof body.question !== 'string') {
        console.warn("Validation failed: 'question' field is missing or not a string.");
        return {
            statusCode: 400,
            headers: {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
            },
            body: JSON.stringify({ message: "'question' field is required and must be a string" })
        };
    }

    const question = body.question;
    const predictionId = `pred-${Date.now()}`;
    console.log(`Generated predictionId: ${predictionId}, Question: "${question}"`);

    try {
        // Call OpenAI API to generate a humorous prediction in German
        console.log("Calling OpenAI API with the question:", question);
        const completion = await openai.chat.completions.create({
            model: "gpt-3.5-turbo",
            messages: [
                { role: "system", content: "You are a helpful assistant." },
                { role: "user", content: `Generiere eine Zukunftsvorhersage basierend auf der Frage: "${question}". Antworte auf die Frage in einer überraschenden, non-konventionellen Art, mit tollem und exquisitem Humor, nicht mehr als 3 Sätze, auf Russisch, im lockeren und freundlichen Stil.` }
            ],
            max_tokens: 200,
            temperature: 0.7
        });

        const prediction = completion.choices[0].message.content.trim();
        console.log("OpenAI response:", prediction);

        // Store the question and prediction in DynamoDB
        const params = {
            TableName: tableName,
            Item: {
                predictionId,
                question,
                prediction
            }
        };
        console.log("Storing the prediction in DynamoDB:", params);

        await dynamodb.put(params).promise();
        console.log("Prediction successfully stored in DynamoDB with ID:", predictionId);

        // Return success response
        return {
            statusCode: 200,
            headers: {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
            },
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
            headers: {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
            },
            body: JSON.stringify({
                message: "Error generating prediction or storing in DynamoDB",
                error: error.message || error
            })
        };
    }
};