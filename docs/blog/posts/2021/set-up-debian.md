---
migrated: true
date:
  created: 2021-03-18
  updated: 2024-04-04
categories:
#   - Howto
  - Linux
tags:
  - Debian
  - Server
  - Howto
  - Setup
  - Hardening
slug: set-up-debian
---

# Set Up Debian

Here are the steps I use to set up and configure a fresh install of Debian on a server.

<!-- more -->

1. Log in as root: `ssh root@<ip or domain.tld>`

2. Change the root password:

    ```shell
    passwd
    ```

3. Update the system:

    ```shell
    apt update && apt upgrade
    ```

4. Configure timezone:

    ```shell
    dpkg-reconfigure tzdata
    ```

5. Configure locales:

    ```shell
    dpkg-reconfigure locales
    ```

6. Install your favourite text editor (here `nano`) and make it the default:

    ```shell
    apt install nano
    update-alternatives --config editor
    ```

Now, create a user for yourself that you will be using and give this user rights to run commands that require root privileges:

1. Create new user:

    ```shell
    adduser <username>
    ```

2. If `sudo` is not installed:

    ```shell
    apt install sudo
    ```

3. Add your user to the `sudo` group:

    ```shell
    usermod -aG sudo <username>
    ```

4. Now, try to log in from a second terminal using that user

5. Optional (but strongly recommended): Add your public key to log in without a password:

    ```shell
    ssh-copy-id <username>@<server IP/domain>
    ```

Now that you have your own user, let's harden the SSH daemon by changing the port and restricting root access from the outside.

1. Edit the `sshd` config:

    ```shell
    nano /etc/ssh/sshd_config
    ```

2. Change `Port` to something other than the default `22`

3. Change `PermitRootLogin` to `no`

4. If you want to disable logins by password and only allow key-based authentication, change `PasswordAuthentication` to `no`

5. Restart `sshd`:

    ```shell
    sudo systemctl restart sshd
    ```

WARNING: Be careful that you don't lock yourself out.
Try to log in from another terminal first to ensure it is working as intended (use `ssh -p <newPort>` if you changed the port).
This gives you the chance to fix the config if it doesn't work as intended.

Now, install a firewall (here `ufw`) to only open the ports that you really need:

1. Install `ufw`:

    ```shell
    apt update && apt install ufw
    ```

2. Create rule to allow SSH port:

    ```shell
    ufw allow <sshPort>/tcp
    ```

    If you use the default port you can also use `ufw allow OpenSSH`.

3. You can also rate limit a port (6 or more connections within 30 seconds):

    ```shell
    ufw limit <port>/tcp
    ```

4. Enable `ufw`:

    > [!CAUTION]
    > Ensure that your rules are correct, otherwise you will lock yourself out in the next step.

    ```shell
    ufw enable
    ```

5. Try to log in from another terminal to verify it is still working.

That's pretty much it.
You might also want to [set up msmtp](./setting-up-msmtp.md) so that you receive email from your system, cron etc.
There are also the following packages I find useful which I install:

- `htop`: Allows to interactively monitor the system resources and processes.
- `icdiff`: A nice tool providing side-by-side comparison with color highlighting.
- `dnsutils`: Essential for diagnosing/testing network stuff.
    For example, it provides _dig_._ntp_: Time synchronization.
- [`curl`](https://curl.se/)
- [`ncdu`](https://dev.yorhel.nl/ncdu): Nice tool to find big files.
- `tree`: A nice tool to show directories in a tree-like format.
