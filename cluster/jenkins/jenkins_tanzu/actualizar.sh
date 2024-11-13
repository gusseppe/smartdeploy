#!/bin/bash

# Variables
JENKINS_VERSION="13.4.25"
CHART_FILE="jenkins-$JENKINS_VERSION.tgz"
JENKINS_VALUES_FILE="config-jenkins.yaml"
RELEASE_NAME="jenkins"

# Actualizar Jenkins usando Helm
echo "Actualizando Jenkins..."
helm upgrade --cleanup-on-fail --install $RELEASE_NAME ./$CHART_FILE --values $JENKINS_VALUES_FILE || { echo "Fallo al actualizar Jenkins."; exit 1; }

echo "Jenkins ha sido actualizado con éxito."
