# renovate: datasource=pypi depName=uv
ARG UV_VERSION=0.12.23
FROM ghcr.io/astral-sh/uv:${UV_VERSION}-python3.14-alpine AS dependencies

WORKDIR /app

RUN --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked

# add venv to search path
ENV PATH=/app/.venv/bin:$PATH


# development server
FROM dependencies AS development

ENTRYPOINT [ "uv", "run", "zensical", "serve" ]


# build site
FROM dependencies AS build

ARG CI=true
ENV CI=${CI}
ARG STATS_WEBSITE_ID
ENV STATS_WEBSITE_ID=${STATS_WEBSITE_ID}

RUN if [[ -z "${STATS_WEBSITE_ID}" ]]; then echo "STATS_WEBSITE_ID missing"; exit 1; fi

COPY . .

# cache currently disabled
# see: https://zensical.org/docs/publish-your-site/#with-github-actions
RUN zensical build --clean --strict


# production
FROM joseluisq/static-web-server:2.44.1@sha256:94618e3d17802265a21926217e6f9e7832b311b6fbf5933684001739fafed06a

COPY deploy/sws.toml /sws.toml

COPY --from=build /app/site /public
