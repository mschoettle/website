---
categories:
#   - Docker
#   - Howto
#   - Nextcloud
#   - Raspberry Pi
  - Self-hosting
date:
  created: 2020-01-16
  updated: 2022-12-17
migrated: true
slug: notes-on-traefik-v2-nextcloud-etc
---

# Notes on traefik v2, Nextcloud, etc

Now that the [Raspberry Pi is set up](./notes-on-setting-up-my-raspberry-pi.md) and [Docker ready to be used](notes-on-docker.md), _Gitea_ is running nicely.
However, without TLS and just accessible by the IP address and port.
So before setting up _Nextcloud_, I wanted to get a reverse proxy ready that also takes care of TLS termination.
I use [traefik](https://traefik.io/traefik/) which supports/integrates with Docker.
Here I document how I configured it to put all my services (this includes Pi-Hole and my router's web interface) behind the reverse proxy with TLS.

At the end, I'll briefly note how Nextcloud is set up.

<!-- more -->

## Setting up _traefik_

A lot of examples out there are still for `v1` so it took a while to get this up and running.
Here is an [interesting post](https://community.traefik.io/t/why-i-still-prefer-v1-over-v2-or-why-i-really-dont-like-to-use-v2/3252) that even though it criticizes `v2` over `v1` it helped me figure out some things.
If you are using traefik `v1` and want to migrate, there is actually a [migration tool](https://github.com/traefik/traefik-migration-tool) that you can use.
Furthermore, the traefik `v2`-specific [Docker 101](https://traefik.io/blog/traefik-2-0-docker-101-fc2893944b9d/) and [TLS 101](https://traefik.io/blog/traefik-2-0-docker-101-fc2893944b9d/) were quite helpful.

The main challenge at the beginning was to realize the difference between _static_ and _dynamic_ configuration.
For some reason I thought that the static configuration is everything that's configured in the configuration file and the dynamic configuration corresponds to what's configured through Docker (using labels).
That's only somewhat correct.
You can also have a dynamic configuration in a file (using the file provider) and there are some options you need to (read: _have to_) define in the dynamic configuration.

NOTE: In the below snippets I use `yaml` as opposed to `toml`.
I find it less verbose and easier to read.

In my static configuration (`traefik.yml`) I have some global options, `entryPoints`, `providers`, and `certificateResolvers`.
There are `entryPoints` for `http` and `https` with `http-to-https` redirection and HTTPS TLS settings (for certificates):

```yaml title="traefik.yml (excerpt)"
entryPoints:
  http:
    address: ":80"
    http:
      redirections:
        entrypoint:
          to: https
  https:
    address: ":443"
    http:
      tls:
        certResolver: letsencrypt
        domains:
          -main: "*.domain.tld"
```

Besides the [Docker provider](https://doc.traefik.io/traefik/providers/docker/) there is a [file provider](https://doc.traefik.io/traefik/providers/file/) that I use for a more "static" dynamic configuration (`dynamic-conf.yml`):

```yaml title="traefik.yml (excerpt)"
providers:
  docker:
    exposedByDefault: false
    defaultRule: "Host(`{{ trimPrefix `/` .Name }}.domain.tld`)"
  file:
    filename: "/config/dynamic-conf.yml"
```

If `exposedByDefault` is `true`, Docker containers will automatically be exposed.
That's where the `defaultRule` comes into play.
I rather decide which containers should be exposed, therefore it is disabled.
With this, you should be able to run a container (here _Gitea_) with the following labels (either provided to `docker run` with `--label` or in your `compose.yaml`):

```yaml title="Adding labels to service in compose file"
labels:
  - "traefik.enable=true"
  # for docker run: replace the ` with \" to avoid command substitution
  - "traefik.http.routers.gitea.rule=Host(`git.domain.tld`)"
  - "traefik.http.routers.gitea.tls=true"
  - "traefik.http.services.gitea.loadbalancer.server.port=3000"
```

So traefik is run with the following volumes:

=== "Using `compose`"

    ```yaml
    volumes:
      - $PWD/traefik.yml:/etc/traefik/traefik.yml
      - $PWD/config:/config
      # Caution: Making the Docker socket read-only does not protect it
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /etc/localtime:/etc/localtime:ro
    ```

=== "Using `docker run`"

    ```shell
    -v $PWD/traefik.yml:/etc/traefik/traefik.yml \
    -v $PWD/config:/config \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /etc/localtime:/etc/localtime:ro \
    ```

### Wildcard Certificates with Let's Encrypt

Instead of creating certificates for each host I use one wildcard certificate.
This is also because I only use the hosts in my home network, so they are not reachable from the outside.
For wildcard certificates, the DNS challenge is required by Let's Encrypt to proof that I own the domain.
Basically it requires the creation of a `TXT` record for the domain during the certificate issuing process.
If you want to get a separate certificate for each (sub-) domain you could use the TLS challenge.
traefik then takes care of it automatically.

Ideally, the DNS challenge is done automatically but it depends on the availability of support for your provider.
Some providers have an API with which it is possible to create and manage DNS entries.
It turns out that there are quite a few libraries out there that support different providers (with varying degrees of overlap).
There is of course [certbot](https://github.com/certbot/certbot).
Then there's [lexicon](https://github.com/AnalogJ/lexicon/) which provides a standardized way to manipulate DNS records for many providers.
There's also [acme.sh](https://github.com/acmesh-official/acme.sh) and [lego](https://github.com/go-acme/lego).
The latter is written in Go and used by traefik.
I unfortunately noticed that too late.
I had already [contributed a provider](https://github.com/AnalogJ/lexicon/pull/469) to `lexicon` (the first time I did something bigger in Python and contributed a PR on GitHub; overall a great experience :slight_smile:).
It would be possible to build a Docker image that combines `certbot` with `lexicon` and takes care of the certificate instead of traefik (in the spirit of separation of concerns).

Anyway, for now it is done manually, which is not too difficult.
So the configuration is as follows in `traefik.yml`:

```yaml title="traefik.yml (excerpt)"
certificatesResolvers:
  letsencrypt:
    acme:
      dnsChallenge:
        provider: manual
        # delayBeforeCheck: 120
      email: someone@example.com
      storage: "/config/acme.json"
      # Staging server
      # caServer: "https://acme-staging-v02.api.letsencrypt.org/directory"
```

TIP: I highly recommend to first try the staging server at the beginning to avoid rate limiting.

With just this, traefik will however not try to request a certificate.
This is where the dynamic configuration comes into play.
So, in the `dynamic-conf.yml` there are the [TLS options](https://doc.traefik.io/traefik/https/tls/) defined:

```yaml title="dynamic-conf.yml"
tls:
  options:
    default:
      minVersion: VersionTLS13
    mintls12:
      minVersion: VersionTLS12
      cipherSuites:
        - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305
        - TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305
```

As you can see above, there is a way to define default [TLS options](https://docs.traefik.io/https/tls/#tls-options).
Mine is quite strict, and it mostly works (the exception at the time of writing being [`curl` on macOS](https://github.com/mschoettle/homebrew-git-curl-openssl)).
Some services don't support TLS 1.3 yet so there is an option to explicitly allow TLS 1.2+.
To reference it you need to append `@file`, i.e., `mintls12@file`.

Now, you need to run traefik manually in interactive mode `docker run -it ...` in order to be able to react to the console messages.
When the certificates are issued, you can stop the container and run it in detached mode (`-d`).

To enable TLS for a container (here Gitea), all you need to add is the label `"traefik.http.routers.gitea.tls=true"`.
To allow `TLS 1.2`, you need to add the label `"traefik.http.routers.gitea.tls.options=mintls12@file"`:

```yaml title="Enabling TLS termination for a service in the compose file"
labels:
  - "traefik.http.routers.gitea.tls=true"
  - "traefik.http.routers.gitea.tls.options=mintls12@file"
```

### Add non-container services

Once it is running it is very simple to enable other services.
For Docker containers you just need to define the four labels as shown above.
For other services you can simply add them to `dynamic-conf.yml` (or create another configuration file if you prefer).
For example, I put Pi-Hole and my router's web interface behind the reverse proxy.
The router has an option for HTTPS, but uses a self-signed certificate.
So initially you get a warning message by your browser.
Here is the configuration for Pi-Hole (the same applies for the router):

```yaml title="Pi-Hole behind a reverse proxy"
http:
  routers:
    pihole:
        rule: Host(`pihole.domain.tld`)
        service: pihole
        tls: {}
  services:
    pihole:
        loadBalancer:
        servers:
            - url: "http://pi.hole:8080"
```

## Setting up Nextcloud

Getting Nextcloud up and running is actually very easy with the provided [Docker examples](https://github.com/nextcloud/docker/tree/master/.examples).
I used the [`docker-compose/insecure/mariadb/fpm/`](https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/insecure/mariadb/fpm/compose.yaml) version as a base and made the following modifications:

- Removed MariaDB and cron services
- Added user-defined bridge network ([see previous post](./notes-on-docker.md))
- Used custom [volume on external drive](./notes-on-setting-up-my-raspberry-pi.md#setting-up-an-external-drive) for Nextcloud app and data
- Added traefik labels to `web` (`nginx`)

Because Nextcloud doesn't know the hostname (such as `nextcloud.domain.tld`) due to the use of the reverse proxy there are a few changes to the Nextcloud configuration necessary.
I had to add/modify the `trusted_proxies` IP, `overwrite.cli.url` and `overwriteprotocol` in the Nextcloud config file (`/path/to/docker-volumes/nextcloud/config/config.php`).
For example:

```php
'overwrite.cli.url' => 'https://nextcloud.domain.tld',
'overwriteprotocol' => 'https',
'trusted_proxies' =>
  array (
    0 => '172.22.0.0/24',
  ),
```

Once Nextcloud is installed you can also set these using `occ`:

```shell
docker compose exec -u www-data app php /var/www/html/occ ...
```

See the documentation for the [configuration commands](https://docs.nextcloud.com/server/latest/admin_manual/occ_command.html#config-commands).

There was a [pull request](https://github.com/nextcloud/docker/pull/1048) that added support for environment variables for these settings as well as a separate config file (`.../nextcloud/config/reverse-proxy.config.php`).

Finally, I changed the background job from Ajax (default) to Cron.
This is switched when the script executes.
I added it to my user's `crontab`.

Execute `crontab -e` and add the following entry:

```text
*/10 * * * * docker exec -u www-data <nextcloud-app-container-name> php -f /var/www/html/cron.php
```

## Putting it all together

If you want to see how this is all put together, check out [my repository on Github](https://github.com/mschoettle/docker/) where you can find all Docker and configuration files for Gitea, traefik, and Nextcloud.

NOTE: This repository hasn't been updated in a while.
I am planning to update this at some point.

> UPDATES: **Updates to this blog post**
>
> - **24.05.2020:** Updated for traefik `v2.2`, added `TLSv1.2` options
> - **17.12.2022:** Added information on Nextcloud config file and new environment variable support
