#!/bin/bash

# Define the input JSON file
INPUT_JSON="input_data.json"

# Check if the input JSON file exists
if [ ! -f "$INPUT_JSON" ]; then
  echo "Archivo de entrada $INPUT_JSON no encontrado!"
  exit 1
fi

# Define the NodePort address
NODE_PORT="30001"
URL="http://localhost:$NODE_PORT/invocations"

# Send a POST request with the input JSON to the model endpoint
echo "Enviando solicitud al modelo en $URL ..."
response=$(curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -d @"$INPUT_JSON")

# Output the response
echo "Respuesta del modelo:"
echo "$response"

