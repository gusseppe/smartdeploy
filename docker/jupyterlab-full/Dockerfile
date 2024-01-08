FROM gusseppe/smartdeploy:base

USER root
# Install Apache Toree
RUN pip install toree
RUN jupyter toree install --sys-prefix --spark_home=${SPARK_HOME} --interpreters=Scala,PySpark,SparkSQL,SparkR,SQL

# Change permissions on the directory for Apache Toree
RUN fix-permissions $CONDA_DIR/share/jupyter

#  Install python packages
COPY requirements.txt ./
RUN pip uninstall ortools
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt-get clean && rm requirements.txt

COPY r_requirements.txt /tmp/
RUN mamba install --quiet --yes --file /tmp/r_requirements.txt && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


USER ${NB_UID}

WORKDIR "${HOME}"
