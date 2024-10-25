---
migrated: true
date:
  created: 2021-05-11
  updated: 2021-05-11
categories:
  - Howto
  - Linux
slug: setting-up-msmtp
---
# Setting up `msmtp`

For a long time I struggled with setting up cronjobs properly.
It always took a lot of trial and error.
Most of the times this was due to [an environment problem](https://serverfault.com/a/449652) (or a typo).
You could [test your cronjob](https://serverfault.com/a/85906) but it would also be nice to be notified whenever something goes wrong (such as your backup script failing).

I had actually seen this output in the syslog before but never really cared much about it:

```output
(CRON) info (No MTA installed, discarding output)
```

_cron_ sends an email whenever a cronjob has an output, unless of course it cannot send the email.

So I recently set up `msmtp` on my server(s).
I started with [these instructions](https://wiki.archlinux.org/index.php/Msmtp) but in the end this is how it is working for me:

1. Install `msmtp`:

    ```shell
    apt update && apt install msmtp
    ```

2. Create the config file `msmtprc` in `/etc` (you might also need one for each user who wants to send email in `~/.msmtprc`)
    * I tried to use [`gpg` for password management](https://wiki.archlinux.org/title/Msmtp#Password_management) to avoid storing the password as plain text.
    However, `gpg` encrypted passwords can not be decrypted with cron/sendmail.
    If you can, use a dedicated email account for this purpose.
    * Set `chmod` for those files to `0600`, otherwise `msmtp` will complain (`sendmail: /home/<user>/.msmtprc: contains secrets and therefore must have no more than user read/write permissions`)
3. For _cron_ to know where to send email to you need to do one of the following:
    * specify default email in `/etc/aliases`
    * specify `MAILTO=recipient@domain.tld` in the `crontab`
4. Finally, _cron_ uses `sendmail` to send out emails.
    For msmtp v1.8.8+ install `msmtp-mta` and set the `set_from_header` [configuration setting](https://marlam.de/msmtp/msmtp.html#Commands-specific-to-sendmail-mode) to `on`.
    The from address can be set to `something <server@domain.tld>` to customize the name display.

    For older versions, you could just install the `msmtp-mta` package.
    However, you then get a `From` header in the emails as "root (Cron Daemon) <>".
    If you want to customize this, create a `sendmail` alias in `/usr/sbin`.
    This is especially handy if you set this up for several servers and want to see which server an email is coming from.
    Follow [these instructions](https://serverfault.com/a/1045006) to properly set it up.

The `msmtp` configuration then looks as follows:

```nginx title="msmtprc"
# find out more about the configuration here: https://marlam.de/msmtp/msmtprc.txt
# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_starttls   on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        /var/log/msmtp
aliases /etc/aliases
set_from_header on

# server
account        server
host           mail.domain.tld
port           587
from           "cron@srv <server@domain.tld>"
user           server@domain.tld
password

# Set a default account
account default : server
```
