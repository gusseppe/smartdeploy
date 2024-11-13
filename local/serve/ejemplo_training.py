import mlflow
import numpy as np
import pandas as pd
from sklearn.ensemble import ExtraTreesClassifier
from mlflow.models.signature import infer_signature
import mlflow.pyfunc

# Clase de modelo personalizada con preprocesamiento
class ExtraTreeModelWithPreprocessing(mlflow.pyfunc.PythonModel):
    def __init__(self, model, preprocessing_steps):
        self.model = model
        self.preprocessing_steps = preprocessing_steps

    def preprocess(self, input_data):
        # Aplica los pasos de preprocesamiento definidos en preprocessing_steps
        # Ejemplo: preprocessing_steps es una función que procesa input_data
        processed_data = self.preprocessing_steps(input_data)
        return processed_data

    def predict(self, context, model_input):
        # Aplica el preprocesamiento
        processed_input = self.preprocess(model_input)
        # Realiza la predicción con los datos preprocesados
        return self.model.predict(processed_input)

# Definir función de preprocesamiento (ejemplo)
def example_preprocessing_steps(input_data):
    # Añade aquí tus pasos de preprocesamiento (e.g., escalado, ingeniería de características)
    # En este ejemplo, input_data es un DataFrame de pandas
    # Este es un ejemplo, se pueden agregar pasos reales según sea necesario
    return input_data

def training(n_estimators=10, random_state=42):
    with mlflow.start_run(run_name='training') as mlrun:
        np.random.seed(random_state)
        X_train = pd.read_csv("X_train.csv")
        X_test = pd.read_csv("X_test.csv")
        y_train = pd.read_csv("y_train.csv")
        y_test = pd.read_csv("y_test.csv")

        model = ExtraTreesClassifier(n_estimators=n_estimators, n_jobs=-1)
        model.fit(X_train, y_train.values.ravel())
        
        # Evaluar el modelo
        test_acc = model.score(X_test, y_test.values.ravel())
        mlflow.log_metric("test_acc", round(test_acc, 3))
        print(f'Accuracy: {round(test_acc, 3)}')
        
        # Registrar parámetros
        mlflow.log_param(key='n_estimators_model', value=n_estimators)
        mlflow.log_param(key='random_state_model', value=random_state)

        # Crear y registrar el modelo personalizado con preprocesamiento
        custom_model = ExtraTreeModelWithPreprocessing(model, example_preprocessing_steps)
        signature = infer_signature(X_train, model.predict(X_train))
        
        mlflow.pyfunc.log_model(
            artifact_path="extratree_with_preprocessing",
            python_model=custom_model,
            signature=signature,
            registered_model_name="extratree_with_preprocessing"
        )

# Ejecutar la función de entrenamiento para guardar el modelo con preprocesamiento
training()
