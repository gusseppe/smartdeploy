#!/bin/bash

# Definir la imagen de Jenkins a descargar
JENKINS_IMAGE="docker.io/bitnami/jenkins:2.462.3-debian-12-r1"
HARBOR_REPO="vcf-np-w2-harbor-az1.sunat.peru/rayserve/jenkins:2.462.3-debian-12-r1"

# Paso 1: Descargar la imagen de Jenkins
echo "Paso 1: Descargando la imagen Docker de Jenkins..."
docker pull $JENKINS_IMAGE

if [ $? -ne 0 ]; then
    echo "Fallo al descargar la imagen: $JENKINS_IMAGE"
    exit 1
fi

echo "Imagen $JENKINS_IMAGE descargada con éxito."

# Paso 2: Subir la imagen de Jenkins a Harbor
echo "Paso 2: Subiendo la imagen de Jenkins a Harbor..."

# Etiquetar la imagen para el repositorio de Harbor
docker tag $JENKINS_IMAGE $HARBOR_REPO

# Iniciar sesión en Harbor
echo "Ingresar credenciales de Harbor:"
docker login vcf-np-w2-harbor-az1.sunat.peru

# Subir la imagen al repositorio de Harbor
docker push $HARBOR_REPO

if [ $? -ne 0 ]; then
    echo "Fallo al subir la imagen a Harbor: $HARBOR_REPO"
    exit 1
fi

echo "Imagen subida exitosamente a Harbor: $HARBOR_REPO"
