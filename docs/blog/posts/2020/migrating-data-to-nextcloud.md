---
migrated: true
date:
  created: 2020-01-14
  updated: 2020-01-14
categories:
#   - Howto
#   - Nextcloud
  - Self-hosting
slug: migrating-data-to-nextcloud
---
# Migrating Data to Nextcloud

If you need to migrate your data to Nextcloud you probably don't want to upload all your files through the web interface.

I suggest to first try the below instructions with a small amount of data (for example, one folder) to verify that it works.
Since Nextcloud runs as a container in my case some of the commands are specific to that, but if you don't you can just use the main command that is executed.

As [previously noted](./notes-on-setting-up-my-raspberry-pi.md), my data was "in the cloud" (encrypted at rest) so not already on an external drive (besides my backup of course).
In general, although it depends on the size of your data, I therefore suggest to copy the data on to an external drive instead of copying it over the network from your machine to your server.
Unless the server is not physically accessible of course (such as a virtual server somewhere).
Even then, you can use the same procedure I used.

<!-- more -->

## Copy data to external drive

For the external drive, I formatted it as _ExFat_ so that my Mac can write to it. On the Raspberry Pi, I had to install `exfat-fuse`.
I tried _FAT32_ as it is supported out-of-the-box by both but it has a limitation on maximum file size.
I considered using _ext4_ but write support on the Mac supposedly is not stable.

If you are copying the data directly to the Nextcloud destination, skip the first step.

First, copy the data to the external drive using [rsync](https://linux.die.net/man/1/rsync) to synchronize the files:

```shell
rsync -rvia --exclude ".DS_Store" <src> <dest>
```

The important argument is `a` which preserves attributes, such as when the files were last modified.
Once the files are synchronized, plug the external drive in to your server and mount it.

Now copy the data to the final destination.
If you are using a Docker [bind mount](https://docs.docker.com/engine/storage/bind-mounts/), you can directly copy them there.
If you are using a named volume, I believe you need to go through a [temporary container to be able to copy files there](https://docs.docker.com/engine/storage/volumes/#back-up-restore-or-migrate-data-volumes).
When Nextcloud adds files and directories it sets certain permissions (`0755` for directories, `0644` for files).
Compared to the `rsync` command above we can fortunately add another argument that allows setting these right away while copying the files.

```shell
rsync -rvia --chmod=D755,F644 --exclude ".DS_Store" <src> <dest>
```

I left the `--exclude` here in case you skipped my first step.
Also note that there is a difference between specifying a trailing slash on the source directory or not.

Now, hand ownership of the data to `www-data` (or whichever user your webserver is set to):

```shell
docker exec chown -R www-data:www-data /var/www/html/data/<user>/files
```

Nextcloud however does not really "know" about these files yet.
Specifically, there is nothing yet in the database regarding these files.
To change that, make Nextcloud scan for files and add them:

```shell
docker exec -u www-data nextcloud-app php /var/www/html/console.php files:scan --all
```

Depending on the size of your data this can run a few minutes (in my case ~3:30 minutes for almost 20000 files).
At the end you should see something like the following output and the files should be shown to you by Nextcloud.

```output
Starting scan for user 1 out of 2 (user1)
Starting scan for user 2 out of 2 (user2)
+---------+-------+--------------+
| Folders | Files | Elapsed time |
+---------+-------+--------------+
| 460     | 16589 | 00:03:27     |
+---------+-------+--------------+
```

**Original Source:** [Tutorial: How to migrate mass data to a new NextCloud server](https://help.nextcloud.com/t/tutorial-how-to-migrate-mass-data-to-a-new-nextcloud-server/9418)
