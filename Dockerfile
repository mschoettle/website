# TODO: update Python version with Renovate somehow
FROM ghcr.io/astral-sh/uv:0.4.24-python3.12-alpine AS dependencies

RUN apk add --no-cache git

WORKDIR /app

COPY pyproject.toml ./
COPY uv.lock ./

RUN uv export --locked --no-dev --output-file requirements.txt
RUN uv pip install --system -r requirements.txt


# development server
FROM dependencies AS development

ENTRYPOINT [ "uv", "run", "mkdocs", "serve" ]


# build site
FROM dependencies AS build

ENV CI=true

COPY . .

RUN python -m mkdocs build --strict --site-dir /site


# production
FROM joseluisq/static-web-server:2.33.0

COPY --from=build /site /public
