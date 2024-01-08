import time
import mlflow
import os

from mlflow.entities import ViewType

from rich.console import Console
console = Console()
client = mlflow.MlflowClient()


def get_last_artifact(path="X_train.csv", experiment_id="0") -> str:
    runs = client.search_runs(experiment_id, run_view_type=ViewType.ACTIVE_ONLY)
    for r in runs:
        if client.list_artifacts(r.info.run_uuid):
            for file in client.list_artifacts(r.info.run_uuid):
                if file.path == path:
                    filepath = os.path.join(r.info.artifact_uri, file.path)
                    timestamp = r.info.start_time
                    dt_object = time.ctime(timestamp/1000.0)
                    console.log(f"Found on this date: {dt_object}")
                    return {"run_uuid": r.info.run_uuid, "artifact_path": filepath}