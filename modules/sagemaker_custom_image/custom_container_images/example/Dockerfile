FROM public.ecr.aws/sagemaker/sagemaker-distribution:latest-cpu

# See documentation for more info https://docs.aws.amazon.com/sagemaker/latest/dg/studio-updated-jl-image-specifications.html

ARG NB_USER="sagemaker-user"
ARG NB_UID=1000
ARG NB_GID=100

ENV MAMBA_USER=$NB_USER

USER root

RUN apt-get update
RUN micromamba install sagemaker-inference --freeze-installed --yes --channel conda-forge --name base

USER $MAMBA_USER

ENTRYPOINT ["jupyter-lab"]
CMD ["--ServerApp.ip=0.0.0.0", "--ServerApp.port=8888", "--ServerApp.allow_origin=*", "--ServerApp.token=''", "--ServerApp.base_url=/jupyterlab/default"]                
            
# install python dependencies
RUN pip install --no-cache --upgrade \
    mlflow