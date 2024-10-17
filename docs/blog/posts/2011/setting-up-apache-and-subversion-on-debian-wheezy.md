---
migrated: true
date:
  created: 2011-03-21
  updated: 2024-10-17
categories:
  - Howto
  - Linux
slug: setting-up-apache-and-subversion-on-debian-wheezy
---
# Setting up Apache and Subversion on Debian Wheezy

In this post I describe how to set up Apache and Subversion on a Debian server.
It is assumed that Apache is already installed and running properly on your server.
This includes PHP if you want to use WebSVN.

<!-- more -->

## Install Subversion

```shell
apt-get install subversion libapache2-svn
```

Create a folder for your repositories, create a repository and change the owner to the user running Apache

```shell
mkdir /home/svn
svnadmin create /home/svn/myRepository
chown -R www-data:www-data /home/svn
```

Edit `/etc/apache2/mods-available/dav_svn.conf` and add this

```apacheconf title="/etc/apache2/mods-available/dav_svn.conf"
<Location /svn>
    DAV svn
    SVNParentPath /home/svn
    AuthType Basic
    AuthName "Subversion Repository"
    AuthUserFile /home/svn/passwd
    AuthzSVNAccessFile /home/svn/authz

    Require valid-user

    SSLRequireSSL
</Location>
```

Activate SSL and the DAV modules on Apache

```shell
a2enmod ssl
a2enmod dav
a2enmod dav_svn
```

Now you need the `authz` and `passwd` file.
The `passwd` file can be created using `htpasswd`

```shell
htpasswd -cm /home/svn/passwd username
```

You will then be asked to enter the password for this user.

For `authz` you can get a sample file from your repository (`conf/authz`).
Copy it to the parent repository location.
To enable your user for the previously created repository add this

```text
[yourrepository:/]
youruser = rw
```

This will give your user read and write permissions for this repository.
Now you can use it through this URL `https://example.com/svn/yourrepository`.

Create a certificate for your site using [Let's Encrypt](https://letsencrypt.org/getting-started/).
If you just want to test this locally, you can also create a self-signed certificate.

??? tip "Create a self-signed certificate"

    ```shell
      openssl req -new -x509 -days 365 -nodes -out apache.pem -keyout apache.key
    ```

    You don't have to enter information when you get asked but some might be helpful.
    It will be valid for 365 days.
    Your browser will tell you that there is a problem with this certificate (since it's not issued by a trusted certificate authority).

Add the certificate files to `/etc/apache2/ssl` (create this directory first).

Create a file for your site in `/etc/apache2/sites-available/`

```apacheconf title="/etc/apache2/sites-available/yourSiteSSL"
<VirtualHost *:443>
 ServerAdmin admin@server.name
 ServerName your.server.name

 DocumentRoot /var/www/yourSiteSSL

 <Directory /var/www/yourSiteSSL>
 Options -Indexes FollowSymLinks
 AllowOverride None
 Order deny,allow
 Allow from all
 </Directory>

 ErrorLog ${APACHE_LOG_DIR}/error_ssl.log
 LogLevel warn
 CustomLog ${APACHE_LOG_DIR}/ssl_access.log combined

 SSLEngine On
 SSLCertificateFile /etc/apache2/ssl/apache.pem
 SSLCertificateKeyFile /etc/apache2/ssl/apache.key
</VirtualHost>
```

Enable your SSL site and restart the server

```shell
a2ensite yoursiteSSL
apache2ctl restart
```

## **Optional:** Install WebSVN

```shell
apt-get install websvn
```

After, the configuration dialog appears.

* Select Apache2 (deselect the others using space)
* Type in the location of the folder with your svn repositories

To make SSL a requirement for WebSVN edit `/etc/websvn/apache.conf` and uncomment `SSLRequireSSL`.
And to restrict access only to authenticated users add this:

```apacheconf
AuthType Basic
AuthName "Subversion Repository"
AuthUserFile /home/svn/passwd

Require valid-user
```

You may notice that the _authz_ line is missing.
This has to be done in the `websvn` config file located in `/etc/websvn/config.php`.
Uncomment this line and add the path to the auth file

```text
$config->useAuthenticationFile('/path/to/authz');
```

## **Optional:** Disable to show the complete server token for Apache

In `/etc/apache2/conf.d/security` change the line

```apacheconf
ServerTokens OS
```

to

```apacheconf
ServerTokens Prod
```
