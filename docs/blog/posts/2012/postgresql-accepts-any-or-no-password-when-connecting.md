---
migrated: true
date:
  created: 2012-05-19
  updated: 2012-05-19
slug: postgresql-accepts-any-or-no-password-when-connecting
---
# PostgreSQL accepts any or no password when connecting

--8<-- "docs/snippets/archive.md"

When connecting to the database with the `postgres` user I realized it accepts any password or no password even though the user has a password set.
I don't know if this happens also when using the installer to install _PostgreSQL_.
In my case I used `initdb` to set it up.

I remember it mentioned something regarding "trust" after setting it up but didn't take much notice until I realized it accepts any password.

In `pg_hba.conf` it adds all local connections to be trusted which means connecting from the same host doesn't require authentication.

```conf
host    all             all             127.0.0.1/32            trust
```

If you don't like that just change it to [another method](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html).
