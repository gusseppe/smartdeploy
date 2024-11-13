#!/bin/bash

PORT=5001

# Define the URL of the served model
MODEL_URL="http://localhost:$PORT/invocations"

# Define the input JSON file
INPUT_JSON="input_data.json"

# Check if the input JSON file exists
if [ ! -f "$INPUT_JSON" ]; then
  echo "Input JSON file $INPUT_JSON not found!"
  exit 1
fi

# Send a POST request with the input JSON to the model endpoint
response=$(curl -s -X POST "$MODEL_URL" \
  -H "Content-Type: application/json" \
  -d @"$INPUT_JSON")

# Output the response
echo "Model response:"
echo "$response"

