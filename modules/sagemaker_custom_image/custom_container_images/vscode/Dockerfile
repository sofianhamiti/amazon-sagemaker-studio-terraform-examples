FROM mambaorg/micromamba:latest
ARG NB_USER="sagemaker-user"
ARG NB_UID=1000
ARG NB_GID=100

USER root

RUN micromamba install -y --name base -c conda-forge sagemaker-code-editor

USER $NB_UID

CMD eval "$(micromamba shell hook --shell=bash)"; \
    micromamba activate base; \
    sagemaker-code-editor --host 0.0.0.0 --port 8888 \
        --without-connection-token \
        --base-path "/CodeEditor/default"