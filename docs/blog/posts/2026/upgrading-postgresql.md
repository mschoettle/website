---
date:
  created: 2026-10-13
tags:
  - postgresql
  - howto
---

# Automatically upgrading PostgreSQL container with `pgautoupgrade`

The [MariaDB container image](https://hub.docker.com/_/mariadb) has an [upgrade option](https://hub.docker.com/_/mariadb#mariadb_auto_upgrade) which will automatically upgrade system tables when switching to a newer version.
The [PostgreSQL container image](https://hub.docker.com/_/postgres) has [no such option](https://github.com/docker-library/postgres/issues/37).
The reason is that it is a bit more involved to do so.
The `pg_upgrade` binary [needs the binaries](https://www.postgresql.org/docs/16/pgupgrade.html) of the previous (current) version and the next version.

There are several options to accomplish this task.
One is to dump and restore the data via `pg_dumpall`.
However, doing this in production can lead to a long downtime depending on the size of the databases.

There are some additional container images that can help with this doing an in-place upgrade:

- [`pgautoupgrade`](https://hub.docker.com/r/pgautoupgrade/pgautoupgrade)
- [`postgres-upgrade`](https://hub.docker.com/r/tianon/postgres-upgrade)

!!! warning "Backup your database first"

    Before doing anything, it is crucial to backup your databases first
    so you can restore if anything goes wrong.

I tried them both and found `pgautoupgrade` to be the easiest.

<!-- more -->

I added `pgautoupgrade` as an additional container in my stack.
Let's assume you have your `postgres` database defined as follows in your compose file:

```yaml
services:
  db:
    image: 
      postgres:15.19-trixie@sha256:c961aa287d8698297cb26cdfadfbe9fd2cbaf77e53cfffe9636e8d8a1e4d842c
    restart: unless-stopped
    ports:
      - 5432:5432
    volumes:
      - postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=${DB_USER:?}
      - POSTGRES_PASSWORD=${DB_PASSWORD:?}
      - POSTGRES_DB=${DB_NAME:?}

volumes:
  postgresql:
```

Simply switching the `image` to a newer version will result in an error.
For example, when switching to `v17` you get this:

```console
db-1  | 2026-10-14 10:14:43.707 UTC [1] FATAL:  database files are incompatible with server
db-1  | 2026-10-14 10:14:43.707 UTC [1] DETAIL:  The data directory was initialized by PostgreSQL version 15, which is not compatible with this version 17.11 (Debian 17.11-1.pgdg13+2).
```

On top of that, in `v18` the [path of the expected volume root changed](https://hub.docker.com/_/postgres#pgdata:~:text=Important%20Change%3A%20the%20PGDATA) from `/var/lib/postgresql/data` to `/var/lib/postgresql/`.
`pgautoupgrade` took care of this as well.

I added an additional container for `pgautoupgrade` to my compose file:

```yaml
pgupgrade:
  image: 
    pgautoupgrade/pgautoupgrade:17.11-trixie@sha256:48d8bdc05f158c2a59258fd9cbb8a3170942c5301f66096d4b1b14737402b3d0
  environment:
    POSTGRES_USER: ${DB_USER:?}
    POSTGRES_PASSWORD: ${DB_PASSWORD:?}
      # don't start postgres afterwards
    PGAUTO_ONESHOT: yes
  volumes:
    - postgresql:/var/lib/postgresql/data
```

Stop your database, then run the `pgupgrade` container:

```shell
docker compose stop db
docker compose run --rm pgupgrade
```

You should see something like "Upgrade to PostgreSQL 17.11 complete." at the end.
Switching the `db` container to the `17.11-trixie` image then starts up normally without any error.

When switching to `v18` you need to drop `/data` from the volume mapping of both containers:

```diff
    volumes:
-      - postgresql:/var/lib/postgresql/data
+      - postgresql:/var/lib/postgresql
```

This allows `pgautoupgrade` to move to the new directory structure.

!!! info "What about cloud-hosted database instances?"

    Cloud providers support this and make it somewhat easier for you.
    For example, in Google Cloud's CloudSQL you can upgrade your instance in-place following their [upgrade guide](https://docs.cloud.google.com/sql/docs/postgres/upgrade-major-db-version-inplace).
