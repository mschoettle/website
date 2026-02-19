---
categories:
  - Linux
date:
  created: 2021-05-12
  updated: 2026-02-09
migrated: true
slug: setting-up-msmtp
tags:
  - automation
  - linux/debian
  - howto
  - self hosting
---

# Setting up `msmtp`

For a long time I struggled with setting up cronjobs properly.
It always took a lot of trial and error.
Most of the times this was due to [an environment problem](https://serverfault.com/a/449652) (or a typo).
You could [test your cronjob](https://serverfault.com/a/85906) using a script or saving the command output to a file but it is still cumbersome.
At the same time, it would also be nice to be notified whenever something goes wrong, such as your backup script failing all of a sudden.

In this post I explain how to set up `msmtp` so that your system will send you emails.

<!-- more -->

I had actually seen this output in ~~syslog~~ `journalctl` before but never really cared much about it:

```output
(CRON) info (No MTA installed, discarding output)
```

_cron_ sends an email whenever a cronjob has an output (unless of course it cannot send the email).

So I set up `msmtp` on my server(s).

Below you can find how I set it up (derived from [these instructions](https://wiki.archlinux.org/index.php/Msmtp)):

1. Install `msmtp`:

    ```shell
    sudo apt update && sudo apt install msmtp
    ```

2. Decide whether you want to set this up system-wide or for a specific user.

    - For the system, create the config file `msmtprc` in `/etc`, for the user, create `.msmtprc` in the user's home directory.

3. Decide how to provide the email password.

    At the end, I resorted to storing the password in plaintext in the config file.
    Here is why:

    `msmtp` recommends one of two methods to store the password: Using an encrypted password file or using the system keyring.

    - **system keyring:** The [msmtp user example](https://marlam.de/msmtp/msmtprc.txt) provides a usage example. I tried to use it by installing `gnome-keyring` but kept getting errors when using `seret-tool store`.
        My research indicates that this is due to running in headless mode.
        So this does not seem to work.

    - **encrypted password file:** I tried to use [`gpg` for password management](https://wiki.archlinux.org/title/Msmtp#Password_management).
        However, `gpg` encrypted passwords can not be decrypted with _cron_/sendmail.

    If you can, use a dedicated email account for this purpose and ensure that only trusted users can access the config file.

4. Set `chmod` for the configuration file(s) to `0600`, otherwise `msmtp` will complain (`sendmail: /home/<user>/.msmtprc: contains secrets and therefore must have no more than user read/write permissions`)

    !!! tip "Examples provided by `msmtp`"

        You can find system and user examples provided by `msmtp` in `/usr/share/doc/msmtp/examples/`.

5. For _cron_ to know where to send email to you need to do one of the following:

    1. specify an [aliases file](https://marlam.de/msmtp/msmtp.html#Aliases-file-1) with a default email in `/etc/aliases`
    2. specify `MAILTO=recipient@domain.tld` in the `crontab`

6. Finally, _cron_ uses `sendmail` to send out emails.
    For current versions of `msmtp` (v1.8.8+) install `msmtp-mta` and set the `set_from_header` [configuration setting](https://marlam.de/msmtp/msmtp.html#Commands-specific-to-sendmail-mode) to `on`.

    ```shell
    sudo apt update && sudo apt install msmtp-mta
    ```

    The from address can be set using `from` and the name using `from_full_name` to customize the name display.
    In my tests with _cron_, setting `from_full_name` has no effect, it will remain as "CronDaemon".
    However, only when `set_from_header` is set to `on`.
    If `set_from_header` is not set, you get something like "root (Cron Daemon)".

    ??? "Sendmail with older `msmtp` versions"

        For older versions, you could just install the `msmtp-mta` package.
        However, you then get a `From` header in the emails as "root (Cron Daemon) \<>".
        If you want to customize this, create a `sendmail` alias in `/usr/sbin`.
        This is especially handy if you set this up for several servers and want to see which server an email is coming from.
        Follow [these instructions](https://serverfault.com/a/1045006) to properly set it up.

The system `msmtp` configuration then looks as follows:

```nginx title="/etc/msmtprc"
# find out more about the configuration here: https://marlam.de/msmtp/msmtprc.txt
# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_starttls   on
logfile        /var/log/msmtp
aliases        /etc/aliases
set_from_header on

# server
account        server
host           mail.domain.tld
port           587
from           server@domain.tld
from_full_name "cron (my cool server)"
user           server@domain.tld
password

# Set a default account
account default : server
```

!!! note "Updates to this blog post"

    - **09.02.2026:** Improved wording and brought it up to date with latest version (based on Debian Trixie).
