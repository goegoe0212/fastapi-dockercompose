# Pythonは公式イメージ
FROM python:3.11.9-slim-bookworm AS base
WORKDIR /usr/src/app
ENV PATH /root/.local/bin:$PATH

FROM base AS build

RUN apt-get update && apt-get install -y \
    curl && \
    rm -rf /var/lib/apt/lists/* &&  \
    curl -sSL https://install.python-poetry.org | python3 - && \
    poetry config virtualenvs.create false

COPY ./app/pyproject.toml /usr/src/app/pyproject.toml

RUN poetry install --no-dev

FROM base AS develop

RUN apt-get update && apt-get install -y \
    git && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /root/.local /root/.local
COPY --from=build /root/.config /root/.config

COPY ./app/pyproject.toml /usr/src/app/pyproject.toml
RUN poetry install

COPY ./ /usr/src/


FROM gcr.io/distroless/python3-debian12:latest AS production
WORKDIR /usr/src/app

# bulid stageからコピー
COPY --from=build /usr/local/lib/python3.11/site-packages /root/.local/lib/python3.11/site-packages
COPY --from=build /usr/local/bin /usr/local/bin
COPY ./ /usr/src/

CMD ["/usr/local/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]