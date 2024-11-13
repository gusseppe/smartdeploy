
# Guía de Usuario

Este repositorio contiene una serie de scripts para gestionar modelos de MLflow, desde la creación de imágenes Docker hasta el envío de solicitudes al modelo servido. La forma recomendada de ejecutar estos scripts es con el siguiente flujo end-to-end. Si el proceso falla en algún paso, puede probar ejecutar cada paso de manera individual.

## Haz ejecutable todos los scripts

chmod +x *.sh

## Ejecución End-to-End

El script `end_to_end.sh` ejecuta el flujo completo desde la creación del Dockerfile hasta el envío de una solicitud al modelo y la compresión del directorio Docker.

## Requisitos previos

**Instalar MLflow**: Asegúrese de tener `mlflow` instalado.
   
   ```bash
   pip install -U mlflow
   ```

**Ejecutar:**

```bash
./end_to_end.sh
```

Este script realiza las siguientes acciones en secuencia:
1. Crea el Dockerfile del modelo.
2. Construye la imagen Docker.
3. Genera el archivo JSON de entrada de prueba.
4. Ejecuta el contenedor Docker con el modelo.
5. Envía una solicitud de prueba al modelo servido.
6. Detiene y limpia el contenedor Docker.
7. Comprime la carpeta `mlflow-docker` en un archivo `.zip`.

Si el script end-to-end falla, puede intentar cada paso individualmente según se detalla a continuación.

## Requisitos previos

1. **Instalar MLflow**: Asegúrese de tener `mlflow` instalado.
   
   ```bash
   pip install -U mlflow
   ```

2. **Configurar el archivo `config`**: Cree un archivo `config` en el directorio principal con los siguientes valores, reemplazando `MODEL_NAME` y `MODEL_VERSION` por el nombre y la versión de su modelo registrados en MLflow.

   ```
   MODEL_NAME=nombre_del_modelo
   MODEL_VERSION=version_del_modelo
   ```

   Por ejemplo:

   ```
   MODEL_NAME=extratree
   MODEL_VERSION=1
   ```

## Scripts y su Uso

### 1. Crear un Dockerfile para el Modelo

El script `create_dockerfile.sh` genera un Dockerfile basado en el modelo especificado en el archivo `config`. Esto es útil para crear una imagen Docker que incluya el modelo y sus dependencias.

**Ejecutar:**

```bash
./create_dockerfile.sh
```

Esto creará un Dockerfile en el directorio `mlflow-docker`.

### 2. Construir la Imagen Docker

El script `build_docker_image.sh` crea una imagen Docker usando el Dockerfile generado en `mlflow-docker`.

**Ejecutar:**

```bash
./build_docker_image.sh
```

Este script construirá la imagen Docker con un nombre basado en `MODEL_NAME` y `MODEL_VERSION`, por ejemplo, `extratree_1`.

### 3. Generar Datos de Entrada de Prueba

El script `generate_input_json.sh` genera un archivo JSON (`input_data.json`) con datos de prueba aleatorios que coinciden con el esquema de entrada del modelo.

**Ejecutar:**

```bash
./generate_input_json.sh
```

Esto creará un archivo llamado `input_data.json` que puede usarse para probar el modelo una vez servido.

### 4. Ejecutar el Contenedor Docker

El script `run_docker_container.sh` ejecuta el contenedor Docker usando la imagen creada y mapea el puerto del contenedor al puerto especificado en el script. Puede ajustar el puerto modificando el valor de `PORT` al inicio del archivo.

**Ejecutar:**

```bash
./run_docker_container.sh
```

Esto iniciará el contenedor y lo hará accesible en `http://localhost:5001` (o el puerto que haya configurado en el script).

### 5. Enviar una Solicitud de Prueba al Modelo Servido

El script `send_request.sh` envía los datos de prueba de `input_data.json` al contenedor Docker que está sirviendo el modelo. Esto le permite verificar que el modelo esté funcionando correctamente.

**Ejecutar:**

```bash
./send_request.sh
```

El script imprimirá la respuesta del modelo, que puede incluir predicciones o resultados en función de los datos de prueba enviados.

### 6. Detener y Limpiar el Contenedor Docker

El script `stop_and_clean_container.sh` detiene y elimina el contenedor Docker creado para el modelo. Esto es útil para liberar recursos después de realizar pruebas.

**Ejecutar:**

```bash
./stop_and_clean_container.sh
```

Este script detendrá y eliminará el contenedor Docker basado en el nombre de modelo (`MODEL_NAME`) definido en el archivo `config`.

### 7. Comprimir la Carpeta Docker

El script `zip_mlflow_docker.sh` comprime la carpeta `mlflow-docker` en un archivo ZIP, usando el nombre y versión del modelo configurados en el archivo `config`.

**Ejecutar:**

```bash
./zip_mlflow_docker.sh
```

Esto creará un archivo `.zip` con el nombre `<MODEL_NAME>_<MODEL_VERSION>.zip` (por ejemplo, `extratree_1.zip`).

## Estructura del Repositorio

- **config**: Archivo de configuración que especifica `MODEL_NAME` y `MODEL_VERSION`.
- **mlflow-docker**: Carpeta donde se genera el Dockerfile.
- **input_data.json**: Archivo JSON generado para proporcionar datos de prueba al modelo.
- **Scripts**:
  - `end_to_end.sh`: Ejecuta el flujo completo de extremo a extremo.
  - `create_dockerfile.sh`: Genera el Dockerfile.
  - `build_docker_image.sh`: Construye la imagen Docker.
  - `generate_input_json.sh`: Genera datos de entrada de prueba.
  - `run_docker_container.sh`: Ejecuta el contenedor Docker.
  - `send_request.sh`: Envía datos de prueba al modelo servido.
  - `stop_and_clean_container.sh`: Detiene y elimina el contenedor.
  - `zip_mlflow_docker.sh`: Comprime la carpeta Docker.

## Notas

- **Personalización del Puerto**: Puede cambiar el puerto en `run_docker_container.sh` ajustando el valor de `PORT` al inicio del script.
- **Requisitos del Entorno**: Asegúrese de que los puertos que utiliza estén disponibles y que Docker esté instalado y en ejecución.

Con estos pasos, debería poder construir, servir y probar su modelo MLflow usando Docker.
