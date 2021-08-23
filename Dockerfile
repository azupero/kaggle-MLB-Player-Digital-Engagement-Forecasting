FROM python:3.8.9-buster

ENV PYTHONUNBUFFERED=1

RUN pip install -U pip poetry

WORKDIR /analysis
COPY poetry.lock pyproject.toml ./

# RUN poetry config virtualenvs.in-project false
RUN poetry config virtualenvs.create false
RUN poetry install
