FROM public.ecr.aws/sagemaker/sagemaker-distribution:latest-cpu

# Set environment variables
ARG NB_USER="sagemaker-user"
ARG NB_UID=1000
ARG NB_GID=100
ENV MAMBA_USER=$NB_USER

USER root

# Install Scrapy
RUN micromamba install -y --name base -c conda-forge scrapy

# Install Code-Server with VSCode= 1.95.3
WORKDIR /tmp
RUN curl -LO https://github.com/coder/code-server/releases/download/v4.95.3/code-server_4.95.3_amd64.deb \
    && sudo dpkg -i code-server_4.95.3_amd64.deb \
    && sudo apt-get install -f \
    && rm code-server_4.95.3_amd64.deb

# Configure Code-Server product.json to support Copilot
RUN curl https://gist.githubusercontent.com/sofianhamiti/ee58ee1d38418c8e778445fdd2cbe844/raw/077d009e9330e2a5921b5b0e0fa92a4c48b19707/product.json > /usr/lib/code-server/lib/vscode/product.json

# Increase file watch limit for code-server
RUN /bin/su -c "echo 'fs.inotify.max_user_watches=524288' >> /etc/sysctl.conf" && \
    sysctl -p

WORKDIR /home/sagemaker-user

# Switch to non-root user
USER $MAMBA_USER

ENTRYPOINT ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8888", "--user-data-dir=/home/sagemaker-user/vscode-config"]                        