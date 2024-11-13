#!/bin/bash

# Variables
JENKINS_VERSION="13.4.25"
CHART_FILE="jenkins-$JENKINS_VERSION.tgz"
CONFIG_FILE="config-jenkins.yaml"
RELEASE_NAME="jenkins"
NAMESPACE="default"

# Step 1: Install Jenkins using Helm
echo "Step 1: Installing Jenkins using Helm..."
helm upgrade --cleanup-on-fail --install $RELEASE_NAME ./$CHART_FILE --values $CONFIG_FILE
if [ $? -ne 0 ]; then
  echo "Failed to install Jenkins. Exiting..."
  exit 1
fi
echo "Jenkins installation initiated."

# Step 2: Wait for Jenkins Pod to be Ready (1/1)
echo "Step 2: Waiting for Jenkins pod to be ready..."
while true; do
  READY_STATUS=$(kubectl get pods -l app.kubernetes.io/name=jenkins -o jsonpath="{.items[0].status.containerStatuses[0].ready}")

  if [ "$READY_STATUS" == "true" ]; then
    echo "Jenkins pod is ready."
    break
  else
    echo "Waiting for Jenkins pod to be ready..."
    sleep 5 # Wait for 10 seconds before checking again
  fi
done

# Step 3: Retrieve the NodePort for Jenkins
echo "Step 3: Retrieving the NodePort for Jenkins..."
NODE_PORT=$(kubectl get svc $RELEASE_NAME -o=jsonpath='{.spec.ports[0].nodePort}')

if [ -z "$NODE_PORT" ]; then
  echo "Failed to retrieve NodePort. Exiting..."
  exit 1
fi

echo "Jenkins is accessible at: http://localhost:$NODE_PORT"

