import numpy as np
import pandas as pd
import time
import mlflow

from mlflow.entities import ViewType
from functools import wraps
from deepchecks.tabular import Dataset
from deepchecks.tabular.checks import WholeDatasetDrift
from deepchecks.tabular.suites import data_integrity
from rich.console import Console

console = Console()


def integrity(x, label=None, data_type='tabular', label_type='classification_label', save_mlflow=False):
    if data_type == 'tabular':
        ds_train = Dataset(x, label=label, cat_features=[], label_type=label_type)
        results = data_integrity().run(ds_train)
        fresults = format_results_integrity(results)
        if save_mlflow:
            flag = all([v["pass"] for v in fresults])
            save_integrity_flag(flag)
        return fresults
    else:
        console.log('Not yet implemented')


def format_results_integrity(results):
    list_results = []
    avoid_results = ["Outlier Sample Detection", "Feature Feature Correlation"]
    for result in results.results:
        metadata = result.get_metadata()
        if metadata["name"] not in avoid_results:
            try:
                d = {"name": metadata['name'],
                     "value": result.value,
                     "description": metadata['summary'],
                     "pass": result.passed_conditions()}
                list_results.append(d)
            except:
                pass

    return list_results


def infer_input(x):
    """
        Infer input type, it can be tabular or image.
    """
    if isinstance(x, pd.DataFrame):
        if len(x.shape) == 2:
            return 'tabular'
        else:
            return 'unkown'
    elif isinstance(x, np.ndarray):
        if len(x.shape) == 2:
            return 'tabular'
        else:
            return 'image'
    else:
        return 'unknown'


def save_integrity_flag(flag):
    with mlflow.start_run(run_name='checker_integrity') as mlrun:
        mlflow.log_param(key='pass_integrity_check', value=flag)


def pass_integrity_check():
    experiment_id = "0"
    flag = mlflow.search_runs(experiment_id,
                              run_view_type=ViewType.ACTIVE_ONLY, 
                              max_results=1)["params.pass_integrity_check"]
    flag = flag.values[0]
    return bool(flag)


def check_integrity(func):
    @wraps(func)  # To keep the original's function signature
    def wrapper(*args, **kwargs):
        flag = pass_integrity_check()
        if flag:
            console.log(f"Check Integrity passed successfully")
            console.log(f"Running {func.__name__!r}")
            start_time = time.perf_counter()
            value = func(*args, **kwargs)
            end_time = time.perf_counter()
            run_time = end_time - start_time
            console.log(f"Finished {func.__name__!r} in {run_time:.4f} secs")
            return value
        else:
            print(f"{func.__name__!r} was not executed. Integrity checking = {flag}")
    return wrapper


def drift(x_inference, x_train, threshold=0.2, 
          save_mlflow=False): # if x_Train is not provided, check the last one from Tracker
    check = WholeDatasetDrift()

    # Podemos agregar condiciones
    # check.add_condition_overall_drift_value_not_greater_than(0.2)

    ds_train = Dataset(x_train, cat_features=[])
    ds_inference = Dataset(x_inference, cat_features=[])

    results = check.run(train_dataset=ds_train, test_dataset=ds_inference)
    flag = results.value["domain_classifier_drift_score"]
    flag = True if flag < threshold else False
    save_drift_flag(flag)
    return results.value
        
        
def save_drift_flag(flag):
    with mlflow.start_run(run_name='checker_drift') as mlrun:
        mlflow.log_param(key='pass_drift_check', value=flag)


def pass_drift_check():
    experiment_id = "0"
    flag = mlflow.search_runs(experiment_id,
                              run_view_type=ViewType.ACTIVE_ONLY, 
                              max_results=1)["params.pass_drift_check"]
    flag = flag.values[0]
    return bool(flag)


def check_drift(func): # refactor with the previous function
    @wraps(func)  # To keep the original's function signature
    def wrapper(*args, **kwargs):
        flag = pass_drift_check()
        if flag:
            console.log(f"Check drift passed successfully")
            console.log(f"Running {func.__name__!r}")
            start_time = time.perf_counter()
            value = func(*args, **kwargs)
            end_time = time.perf_counter()
            run_time = end_time - start_time
            console.log(f"Finished {func.__name__!r} in {run_time:.4f} secs")
            return value
        else:
            print(f"{func.__name__!r} was not executed. Integrity checking = {flag}")
    return wrapper