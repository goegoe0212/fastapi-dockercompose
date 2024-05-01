# Pythonは公式イメージ
FROM python:3.12.3-slim-bookworm AS base

# 作業ディレクトリを設定
WORKDIR /usr/src/app

FROM base AS build
# 必要なツール群のインストール
ENV PATH /root/.local/bin:$PATH

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 - && \
    poetry config virtualenvs.create false

FROM base AS production
COPY --from=build /root/.local /root/.local
COPY --from=build /root/.config /root/.config
COPY ./ /usr/src/

RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*


ENV PATH=/root/.local/bin:$PATH