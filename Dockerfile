# Pythonは公式イメージ
FROM python:3.12.3-slim-bookworm AS base
WORKDIR /usr/src/app


FROM base AS build
ENV PATH /root/.local/bin:$PATH

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 - && \
    poetry config virtualenvs.create false

FROM base AS production

RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /root/.local /root/.local
COPY --from=build /root/.config /root/.config
COPY ./ /usr/src/




ENV PATH=/root/.local/bin:$PATH