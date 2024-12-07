# See documentation for more info https://docs.aws.amazon.com/sagemaker/latest/dg/code-editor-custom-images-specifications.html

FROM public.ecr.aws/sagemaker/sagemaker-distribution:latest-cpu
ARG NB_USER="sagemaker-user"
ARG NB_UID=1000
ARG NB_GID=100
ENV MAMBA_USER=$NB_USER

USER root

 # install scrapy in the base environment
RUN micromamba install -y --name base -c conda-forge scrapy

 # download VSCodeVim
RUN \
  wget https://github.com/VSCodeVim/Vim/releases/download/v1.27.2/vim-1.27.2.vsix \
  -P /tmp/exts/ --no-check-certificate

 # Install the extension
RUN \
  extensionloc=/opt/amazon/sagemaker/sagemaker-code-editor-server-data/extensions \
  && sagemaker-code-editor \
    --install-extension "/tmp/exts/vim-1.27.2.vsix" \
    --extensions-dir "${extensionloc}"

USER $MAMBA_USER
ENTRYPOINT ["entrypoint-code-editor"]

# install additional libraries
RUN pip install --no-cache --upgrade \
    mlflow==2.11.1