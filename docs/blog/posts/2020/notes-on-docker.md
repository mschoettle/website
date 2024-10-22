---
migrated: true
date:
  created: 2020-01-08
  updated: 2024-10-23
categories:
  - Docker
  - Howto
  - Raspberry Pi
slug: notes-on-docker
---
# Notes on Docker

I've never really followed the hype around Docker but to be honest also never really taken the time to look into it more.
That's until my friend [Harald](https://jesinger.net/) told me that he is using it on his Raspberry Pi to run some services.
What sounded appealing is that you can reproduce builds, you are not "polluting" the host system, you can keep all configs etc. in one place, and move your services somewhere else quickly.
The latter is especially interesting when you want to reinstall the host system.
Furthermore, you can put the build as well as configuration in version control.
Of course, you are adding another layer of complexity in the mix.
I thought I'd give it a try.
Here are some notes pertinent to [the setup with my Raspberry Pi](./notes-on-setting-up-my-raspberry-pi.md).

<!-- more -->

## Docker images for arm32v6/7 architecture

While the _Raspberry Pi 4_ has a 64bit CPU, _Raspbian_ is 32bit.
The main reason is [backwards compatibility](https://forums.raspberrypi.com/viewtopic.php?t=252369#p1539974) to older Raspberry Pi models.
This can sometimes be a problem if an image is not provided for ARM 32bit architectures.
One example is [Gitea](https://gitea.io/) which so far is the only one where I encountered this.
Fortunately, they provide an `arm32v6` binary in their releases so it was not too difficult to create a `Dockerfile` that downloads the binary.
There are other Docker images that compile _Gitea_ for the specific ARM architecture but there doesn't seem to be a big advantage in using _ARMv6_ vs. _ARMv7_ (see [differences](http://single-boards.com/armv6-vs-armv7/) and see [comparison benchmark](https://www.mikronauts.com/raspberry-pi/raspberry-pi-2-raspbian-vs-linero-armv6-vs-armv7/)).

My `Dockerfile` is based on the [official one](https://github.com/go-gitea/gitea/blob/master/Dockerfile).
You can find it in my [repository on GitHub](https://github.com/mschoettle/docker/tree/master/gitea).
The main difference is that instead of compiling Gitea it downloads the binary and corresponding repository for the specific release.

## Docker and `ufw`

As outlined [previously](./notes-on-setting-up-my-raspberry-pi.md), I use `ufw` as a frontend for `iptables`.
Unfortunately, Docker directly manipulates `iptables` which means that published ports are accessible from the outside even if no _allow_ rule is added with/to `ufw`.
There is a [workaround](https://github.com/moby/moby/issues/4737) which requires disabling `iptables` manipulation by Docker but [they generally don't recommend turning this setting off](https://docs.docker.com/network/iptables/#prevent-docker-from-manipulating-iptables).
Someone created [another solution](https://github.com/chaifeng/ufw-docker) which leaves `iptables` manipulation by Docker intact but I haven't tried it out myself.

In my case since I intended to use a reverse proxy, the only ports exposed to the outside are `80` and `443` for the reverse proxy.
The ports of the containers are [only exposed and not published](https://docs.docker.com/engine/reference/commandline/run/#publish-or-expose-port--p---expose).
Therefore, I just left it as it is and did not use any of the workarounds.

## Creating a user-defined network

I created a [bridge network](https://docs.docker.com/network/bridge/) which allows the containers within that network to communicate.
There are a lot of options.
I used the following command:

```shell
docker network create --driver bridge <networkname>
```

With `docker network inspect <networkname>` you can then find out the subnet and gateway and use the gateway as the IP address to bind _MariaDB_ to (see above) and subsequently use it as the host to connect to it from clients.

There are [advanced options](https://docs.docker.com/engine/reference/commandline/network_create/#bridge-driver-options) you can make use of, for example, I used the following command:

```shell
docker network create \
    --driver bridge \
    --gateway 172.22.0.1 \
    --subnet 172.22.0.0/16 \
    -o "com.docker.network.bridge.enable_ip_masquerade=true" \
    -o "com.docker.network.bridge.name=docker-<networkname>" \
    -o "com.docker.network.bridge.enable_icc=true" \
    -o "com.docker.network.driver.mtu=1500" \
    <networkname>
```

When you create containers you need to add `--network <networkname>` as an argument.
If you are using `compose`, you can specify the following to have all containers be part of this network:

```yaml
networks:
  default:
    name: <networkname>
    external: true
```

## Running the database on the host

As outlined previously, I have a _MariaDB_ instance running on the host.
Why is it not running in a container? I did consider it but containers are supposed to be stateless and the [general recommendation is to not run production databases in Docker](https://vsupalov.com/database-in-docker/).
There is an interesting discussion about this on [Reddit](https://www.reddit.com/r/docker/comments/amo2cc/running_production_databases_in_docker/) as well.
In the end, it seemed like a risk (which I am not willing to take).

This of course makes it a bit more tricky when you want to connect to the database from within a container.
By default, this doesn't work unless you use [host networking](https://docs.docker.com/network/host/).
But this seemed less practical since the network of the container is not isolated from the host.

There are two things to consider.
The IP address _MariaDB_ binds itself to to listen for connections, and the host name users are allowed to connect from.
By default, _MariaDB_ binds itself to localhost (`127.0.0.1`).
You could of course bind to any IP address (`0.0.0.0`) and then connect through the hosts IP address.
I didn't want to open it up like this so I used the user-defined bridge network I described above.
_MariaDB_ is then bound to the host IP of that network.
A disadvantage is that then only Docker containers within that network can access the database.
So if you have any other application on the host that needs to access the database that doesn't work.

When creating database users, instead of specifying `'user'@'localhost'` you could say `'user'@'172.22.0.%'`. This assumes that your subnet is `172.22.0.0/24`.
This way you don't need to know the specific IP address of a container.
Also, the IP address of a container is not guaranteed to be the same if you restart your containers.
To create a database with a user do the following in the SQL console (when running `sudo mysql` from the host):

```sql
CREATE DATABASE <dbname>;
GRANT ALL PRIVILEGES ON <dbname>.* TO '<username>'@'172.22.0.%' identified by 'my-super-long-secret-password';
FLUSH PRIVILEGES;
```

## Using the host timezone in containers

If ever you perform a `docker logs <containername>` you most likely will notice that the timezone does not match your host's timezone (unless you happen to live in the _GMT_ timezone :smile:).
By default, [Docker syncs the time but not timezone](https://stackoverflow.com/q/22800624), so the timezone is `GMT`/`UTC`.
Some images do support the [setting of an environment variable](https://github.com/docker-library/redis/issues/127) `TZ` specifying the timezone but it is not always the case. If you want to support this for your own image, you need to install the `tzdata` system package.
However, you can also simply add a bind mount to your volumes:

```yaml
volumes:
  - /etc/localtime:/etc/localtime:ro
```

This way, irregardless of the host on which a container is run, the timezone matches the one of the host.

> UPDATES: **Updates to this blog post**
>
> * **23.10.2024:** Updated default network format in `compose` example to current format.
