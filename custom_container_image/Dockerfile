FROM python:3.12-slim


ENV PYTHONUNBUFFERED=TRUE

# install gcc
RUN apt-get update \
    && apt-get install -y gcc git \
    && apt-get clean

# install python dependencies
RUN pip install --no-cache --upgrade \
    mlflow