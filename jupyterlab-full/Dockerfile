FROM gusseppe/smartdeploy:base

USER root
# Install Apache Toree
RUN pip install toree
RUN jupyter toree install --sys-prefix --spark_home=${SPARK_HOME} --interpreters=Scala,PySpark,SparkSQL,SparkR,SQL

# Change permissions on the directory for Apache Toree
RUN fix-permissions $CONDA_DIR/share/jupyter

#  Install python packages
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt-get clean && rm requirements.txt

USER ${NB_UID}

WORKDIR "${HOME}"
