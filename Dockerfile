# TODO: update Python version with Renovate somehow
FROM ghcr.io/astral-sh/uv:0.9.24-python3.13-alpine AS dependencies

COPY --from=ghcr.io/astral-sh/uv:0.9.24 /uv /uvx /bin/

RUN apk add --no-cache git pngquant cairo

WORKDIR /app

RUN --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked

# add venv to search path
ENV PATH=/app/.venv/bin:$PATH


# development server
FROM dependencies AS development

ENTRYPOINT [ "uv", "run", "mkdocs", "serve" ]


# build site
FROM dependencies AS build

ARG CI=true
ENV CI=${CI}
ARG STATS_WEBSITE_ID
ENV STATS_WEBSITE_ID=${STATS_WEBSITE_ID}

RUN if [[ -z "${STATS_WEBSITE_ID}" ]]; then echo "STATS_WEBSITE_ID missing"; exit 1; fi

COPY . .

RUN python -m mkdocs build --strict --site-dir /site


# production
FROM joseluisq/static-web-server:2.40.1

COPY deploy/sws.toml /sws.toml

COPY --from=build /site /public
