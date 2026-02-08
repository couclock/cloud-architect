"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = void 0;
const client_bedrock_runtime_1 = require("@aws-sdk/client-bedrock-runtime");
const client = new client_bedrock_runtime_1.BedrockRuntimeClient({
    region: "eu-west-1"
});
import { APIGatewayProxyEventV2 } from "aws-lambda";

/*

{
  "version": "2.0",
  "routeKey": "POST /utilities/yfinance/search",
  "rawPath": "/utilities/yfinance/search",
  "rawQueryString": "",
  "headers": {
    "content-type": "application/json"
  },
  "requestContext": {
    "http": {
      "method": "POST",
      "path": "/utilities/yfinance/search",
      "protocol": "HTTP/1.1",
      "sourceIp": "127.0.0.1",
      "userAgent": "Mozilla/5.0"
    }
  },
  "body": "{\"prompt\":\"tell me a joke in french\"}",
  "body": "{\"prompt\":\"you're a financial advisor and I want you to give your best stock portfolio including 5 stocks to get the best performance in next 5 years. Give me the result as a formatted json object. No mention of your reasonning, only the result.\"}",
  "isBase64Encoded": false
}


*/
const handler = async (event: APIGatewayProxyEventV2) => {
    try {
        // --- API Gateway v2 : body est une string ---
        if (!event.body) {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: "Missing request body" }),
            };
        }
        const body = JSON.parse(event.isBase64Encoded
            ? Buffer.from(event.body, "base64").toString("utf-8")
            : event.body);
        const prompt = body.prompt;
        if (!prompt) {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: "Missing prompt" }),
            };
        }

        // console.log("AWS_REGION:", process.env.AWS_REGION);

        const command = new client_bedrock_runtime_1.InvokeModelCommand({
            modelId: "nvidia.nemotron-nano-9b-v2",
            contentType: "application/json",
            accept: "application/json",
            body: JSON.stringify({
              response_format: {
                type: "json_schema",
                json_schema: {
                  name: "portfolio",
                  schema: {
                    type: "object",
                    properties: {
                      portfolio: {
                        type: "array",
                        items: {
                          type: "object",
                          properties: {
                            ticker: { type: "string" },
                            company: { type: "string" },
                            sector: { type: "string" },
                            investment_thesis: { type: "string" },
                            allocation_percent: { type: "number" }
                          },
                          required: [
                            "ticker",
                            "company",
                            "sector",
                            "investment_thesis",
                            "allocation_percent"
                          ]
                        }
                      }
                      
                    },
                    required: [
                      "portfolio"
                    ]
                  }
                }
              },
              messages: [
                {
                  role: "system",
                  content: [
                    {
                      type: "text",
                      text: "Return ONLY a JSON object matching the provided schema and using as ticker the yahoo ticker format"
                    }
                  ]
                },
                {
                  role: "user",
                  content: [
                    {
                      type: "text",
                      text: prompt
                    }
                  ]
                }
              ]
            }),
          });
        console.log("Sending command to Bedrock...");
        const response = await client.send(command);
        console.log("Bedrock response received");
        
        const decoded = new TextDecoder().decode(response.body);
        console.log("Decoded response:", decoded);

        const responseBody = JSON.parse(decoded);
        const responseText = responseBody.choices[0].message.content;

        console.log("Success response sent");

        return {
            statusCode: 200,
            headers: {
              "Content-Type": "application/json"
            },
            body: responseText,
        };
    }
    catch (error:unknown) {
      console.error("Handler error caught:", {
            error: error instanceof Error ? error.message : String(error),
            stack: error instanceof Error ? error.stack : "No stack trace",
            type: typeof error
        });
        return {
            statusCode: 500,
            body: JSON.stringify({
                error: "Bedrock invocation failed",
                message: error instanceof Error ? error.message : String(error)
            }),
        };
    }
};
exports.handler = handler;
