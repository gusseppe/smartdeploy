
# Guía para Desplegar y Probar el Modelo en el Clúster de Kubernetes

Esta guía describe los pasos para desplegar y probar el modelo en un clúster de Kubernetes utilizando los scripts proporcionados.

## Haz ejecutable todos los scripts

chmod +x *.sh

## Paso 1: Configuración Inicial

Antes de iniciar el despliegue, asegúrese de haber llenado el archivo `deploy` para especificar el registro de Docker (Docker registry) donde se subirá la imagen del modelo. En este archivo, defina los valores necesarios como `DOCKER_REGISTRY`, `MODEL_NAME`, `MODEL_VERSION`, y `TAG`.

## Paso 2: Ejecución del Script End-to-End

Una vez configurado el archivo `deploy`, puede ejecutar el script `end_to_end_cluster.sh`, el cual realizará todos los pasos necesarios para construir, subir, desplegar y probar el modelo en el clúster de Kubernetes.

**Ejecute el script con:**

```bash
./end_to_end_cluster.sh
```

Este script completará los siguientes pasos automáticamente:

1. Construirá la imagen Docker del modelo.
2. Etiquetará y subirá la imagen al repositorio especificado.
3. Creará los archivos YAML para el despliegue en Kubernetes.
4. Desplegará el modelo en el clúster de Kubernetes.
5. Enviará una solicitud al modelo en el pod desplegado para verificar que funcione correctamente.

## Paso 3: Ejecución Paso a Paso (Opcional)

Si el script `end_to_end_cluster.sh` falla en algún paso, puede ejecutar cada paso de manera individual con los scripts correspondientes. Los pasos se encuentran en el mismo orden que en el script `end_to_end_cluster.sh` y son:

1. `build_docker_image.sh`: Construye la imagen Docker del modelo.
2. `docker_push_image.sh`: Etiqueta y sube la imagen Docker al repositorio.
3. `create_k8s_yaml.sh`: Crea los archivos YAML para el despliegue en Kubernetes.
4. `deploy_to_k8s.sh`: Despliega el modelo en el clúster de Kubernetes.
5. `send_request_to_pod.sh`: Envía una solicitud al modelo en el pod.

## Paso 4: Remover el Despliegue

Para remover el despliegue y liberar los recursos en el clúster, puede utilizar el script `remove_from_k8s.sh`, el cual eliminará el servicio y el despliegue asociados al modelo.

**Ejecute el script con:**

```bash
./remove_from_k8s.sh
```

Este script se encargará de limpiar todos los recursos del modelo en el clúster.

## Nota Final

Siguiendo esta guía, debería poder desplegar y probar su modelo en el clúster de Kubernetes de manera efectiva.
