# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Modified by Gusseppe Bravo

ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/pyspark-notebook:python-3.8
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
RUN  pip3 install --upgrade pip==23.0.1 && pip3 install --no-cache-dir  --upgrade  elyra[all]==3.14.3
RUN jupyter lab  build --dev-build=False --minimize=False

#  Install python packages
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt-get clean && rm requirements.txt


USER ${NB_UID}

WORKDIR "${HOME}"
