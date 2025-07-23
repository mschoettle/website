# TODO: update Python version with Renovate somehow
FROM ghcr.io/astral-sh/uv:0.7.22-python3.13-alpine AS dependencies

COPY --from=ghcr.io/astral-sh/uv:0.7.22 /uv /uvx /bin/

RUN apk add --no-cache git

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

ENV CI=true

COPY . .

RUN python -m mkdocs build --strict --site-dir /site


# production
FROM joseluisq/static-web-server:2.36.1

COPY deploy/sws.toml /config.toml

COPY --from=build /site /public
