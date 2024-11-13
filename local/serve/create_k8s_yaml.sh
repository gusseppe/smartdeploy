#!/bin/bash

# Define the deploy file
DEPLOY_FILE="deploy"

# Check if the deploy file exists
if [ ! -f "$DEPLOY_FILE" ]; then
  echo "Archivo de despliegue $DEPLOY_FILE no encontrado!"
  exit 1
fi

# Read DOCKER_REGISTRY, MODEL_NAME, MODEL_VERSION, and TAG from the deploy file
DOCKER_REGISTRY=$(grep -w "DOCKER_REGISTRY" "$DEPLOY_FILE" | cut -d '=' -f 2)
MODEL_NAME=$(grep -w "MODEL_NAME" "$DEPLOY_FILE" | cut -d '=' -f 2)
MODEL_VERSION=$(grep -w "MODEL_VERSION" "$DEPLOY_FILE" | cut -d '=' -f 2)
TAG=$(grep -w "TAG" "$DEPLOY_FILE" | cut -d '=' -f 2)

# Check if the values are set
if [ -z "$DOCKER_REGISTRY" ] || [ -z "$MODEL_NAME" ] || [ -z "$MODEL_VERSION" ] || [ -z "$TAG" ]; then
  echo "Algunos valores faltan en el archivo de despliegue."
  exit 1
fi

# Construct the full Docker image name with version
IMAGE_NAME="${DOCKER_REGISTRY}/${MODEL_NAME}_${MODEL_VERSION}:${TAG}"

# Create the Kubernetes deployment file (model-deployment.yaml)
echo "Creando archivo model-deployment.yaml..."
cat <<EOF > model-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${MODEL_NAME}-${MODEL_VERSION}-deployment
  labels:
    app: ${MODEL_NAME}
    version: "${MODEL_VERSION}"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${MODEL_NAME}
      version: "${MODEL_VERSION}"
  template:
    metadata:
      labels:
        app: ${MODEL_NAME}
        version: "${MODEL_VERSION}"
    spec:
      containers:
      - name: ${MODEL_NAME}-${MODEL_VERSION}-container
        image: ${IMAGE_NAME}
        ports:
        - containerPort: 8080
EOF

# Create the Kubernetes service file (model-service.yaml) with NodePort as default and LoadBalancer as commented option
echo "Creando archivo model-service.yaml..."
cat <<EOF > model-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: ${MODEL_NAME}-${MODEL_VERSION}-service
  labels:
    app: ${MODEL_NAME}
    version: "${MODEL_VERSION}"
spec:
  type: NodePort
  selector:
    app: ${MODEL_NAME}
    version: "${MODEL_VERSION}"
  ports:
  - protocol: TCP
    port: 5001        # External access port
    targetPort: 8080  # Target port inside the container
    nodePort: 30001   # Specify the node port

# Uncomment the following lines to use LoadBalancer instead of NodePort
#  type: LoadBalancer
#  ports:
#  - protocol: TCP
#    port: 5001        # External access port
#    targetPort: 8080  # Target port inside the container
EOF

echo "Archivos model-deployment.yaml y model-service.yaml creados con éxito."

