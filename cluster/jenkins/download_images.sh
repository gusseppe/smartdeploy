#!/bin/bash

# Define the config file
CONFIG_FILE="config-jenkins.yaml"

# Function to extract image details
extract_images() {
    # Extract images from the config-jenkins.yaml file
    IMAGES=($(grep -E "registry|repository|tag" $CONFIG_FILE | awk '{print $2}' | paste - - -))

    for ((i=0; i<${#IMAGES[@]}; i+=3)); do
        registry=${IMAGES[i]}
        repository=${IMAGES[i+1]}
        tag=${IMAGES[i+2]}

        # Construct the image string
        if [ "$registry" != "null" ]; then
            image="$registry/$repository:$tag"
        else
            image="$repository:$tag"
        fi

        echo "Downloading Docker image: $image"
        docker pull $image

        if [ $? -ne 0 ]; then
            echo "Failed to download image: $image"
            exit 1
        fi
    done
}

# Step 1: Extract and download images
echo "Step 1: Extracting and downloading images from $CONFIG_FILE..."
extract_images

echo "All images have been downloaded successfully."

