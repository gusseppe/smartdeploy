# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Modified by Gusseppe Bravo

ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/all-spark-notebook:python-3.8
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV JUPYTER_ENABLE_LAB=yes
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install nodejs
# Node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version

# Install Elyra
RUN  pip3 install --upgrade pip==23.0.1  && pip3 install --no-cache-dir  --upgrade  elyra[all]==3.14.3
RUN jupyter lab  build --dev-build=False --minimize=False

#  Install python packages
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt-get clean && rm requirements.txt


# R packages, IRKernel is included in the base image
# r-e1071: dependency of the caret R package
RUN mamba install --quiet --yes \
    'r-caret' \
    'r-crayon' \
    'r-devtools' \
    'r-e1071' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-nycflights13' \
    'r-randomforest' \
    'r-dplyr' \
    'r-data.table' \
    'r-mlflow' \
    'r-xgboost' \
    'r-tidyr' \
    'r-rcurl' \
    'r-rmarkdown' \
    'r-tidyverse' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# `rpy2` and `r-tidymodels` are not easy to install under aarch64
RUN set -x && \
    arch=$(uname -m) && \
    if [ "${arch}" == "x86_64" ]; then \
        mamba install --quiet --yes \
            'rpy2' \
            'r-tidymodels' && \
            mamba clean --all -f -y && \
            fix-permissions "${CONDA_DIR}" && \
            fix-permissions "/home/${NB_USER}"; \
    fi;


# Install Apache Toree
RUN pip install toree
RUN jupyter toree install --sys-prefix --spark_home=${SPARK_HOME} --interpreters=Scala,PySpark,SparkSQL,SparkR,SQL

# Change permissions on the directory for Apache Toree
RUN fix-permissions $CONDA_DIR/share/jupyter


USER ${NB_UID}

WORKDIR "${HOME}"
