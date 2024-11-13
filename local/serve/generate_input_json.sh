#!/bin/bash

# Set required environment variables
export MLFLOW_TRACKING_URI=http://localhost:5000
export MLFLOW_S3_ENDPOINT_URL=http://localhost:9000
export AWS_ACCESS_KEY_ID=minio
export AWS_SECRET_ACCESS_KEY=minio123

# Define the configuration file
CONFIG_FILE="config"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file $CONFIG_FILE not found!"
  exit 1
fi

# Read MODEL_NAME and MODEL_VERSION directly from the file
MODEL_NAME=$(grep -w "MODEL_NAME" "$CONFIG_FILE" | cut -d '=' -f 2)
MODEL_VERSION=$(grep -w "MODEL_VERSION" "$CONFIG_FILE" | cut -d '=' -f 2)

# Check if the variables are set
if [ -z "$MODEL_NAME" ] || [ -z "$MODEL_VERSION" ]; then
  echo "MODEL_NAME or MODEL_VERSION is not set in the configuration file."
  exit 1
fi

# Define the output JSON file name
OUTPUT_JSON="input_data.json"

# Python helper to retrieve the input schema and generate random JSON data
python3 - <<EOF
import mlflow
import json
import random
import sys
from mlflow.types import DataType

# Retrieve MODEL_NAME and MODEL_VERSION from arguments
model_name = "$MODEL_NAME"
model_version = "$MODEL_VERSION"

# Load the model from the MLflow registry
try:
    model_uri = f"models:/{model_name}/{model_version}"
    model = mlflow.pyfunc.load_model(model_uri)

    # Infer the input schema
    signature = model.metadata.get_input_schema()
    if not signature:
        print("Failed to retrieve input schema.")
        sys.exit(1)

    # Generate random data based on the schema
    input_data = {}
    for input_col in signature.inputs:
        if input_col.type == DataType.double or input_col.type == DataType.float:
            input_data[input_col.name] = round(random.uniform(0, 1), 3)  # Random float
        elif input_col.type == DataType.integer:
            input_data[input_col.name] = random.randint(0, 100)  # Random integer
        elif input_col.type == DataType.string:
            input_data[input_col.name] = "sample_string"  # Sample string
        else:
            input_data[input_col.name] = "unsupported_type"

    # Create JSON data structure
    json_data = {"dataframe_records": [input_data]}

    # Write to JSON file
    with open("$OUTPUT_JSON", "w") as f:
        json.dump(json_data, f, indent=2)

    print(f"Sample input JSON data has been saved to $OUTPUT_JSON")

except Exception as e:
    print(f"Error loading model '{model_name}' version '{model_version}': {e}")
    sys.exit(1)
EOF

