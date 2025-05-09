---
migrated: true
date:
  created: 2020-01-06
  updated: 2024-10-22
categories:
#   - Howto
#   - Raspberry Pi
  - Self-hosting
tags:
  - Raspberry Pi
  - Howto
  - Setup
slug: notes-on-setting-up-my-raspberry-pi
---

# Notes on Setting Up My Raspberry Pi

I recently purchased a [Raspberry Pi 4 Model B](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) for some projects at home.
Here are some notes on how I set it up/what I did.
They are mostly for my _future self_ but might be helpful to others that try to do something similar.

<!-- more -->

Basically, the main goal was to use it for [Pi-Hole](https://pi-hole.net/) (network-wide ad blocking on the DNS level), [Gitea](https://about.gitea.com) (self-hosted git service), and to set up a private cloud for all our data (using [Nextcloud](https://nextcloud.com/)) instead of having them with one of the cloud providers.
So far we used [Boxcryptor](https://www.boxcryptor.com) to encrypt the data and store it in the cloud but it makes it a bit inconvenient for pictures since you can't see a preview (thumbnail).
Since there is potentially a lot of data I intended to store the data on an external drive.
The Pi4 has USB3 so I mounted a solid state drive (SSD) using a SATA-to-USB3 enclosure/adapter.

## Preparing the Raspbian Image

Most guides mention the use of an HDMI cable when setting up the Raspberry Pi (using _NOOBS_ to select to install Raspbian from a screen).
However, that's not necessary if you just want to use it as a server and intend to SSH into it (called _headless setup_).

I simply downloaded the [Raspbian Buster Lite image](https://www.raspberrypi.org/downloads/raspbian/) and wrote it to the Micro SD card.
You can use the recommended [Etcher](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) tool but existing Unix system tools are sufficient if you have access to a terminal.
Since I am on a Mac I followed the [instructions](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md) from the Official Raspberry Pi Documentation.

The last step in preparation is to enable SSH for the headless setup.
By default it is not enabled.
To enable it, a file called `ssh` needs to be added to the root of the volume on the Micro SD card.
See [step 3 of the SSH Pi documentation](https://www.raspberrypi.org/documentation/remote-access/ssh/README.md) for more details.
Basically `cd` to the root of the volume (most likely `/Volumes/boot`) on your machine and do `touch ssh`.

With this it is possible to plug the card into the RPi and boot it.
Then `ssh pi@<IPOfRaspberryPi>` should work.

## Setting Up Raspbian

Since Raspbian is based on Debian you can follow [any guide on initial server setup for Debian](../2021/set-up-debian.md) (or Raspbian).
In short, I basically did the following steps:

- Update Raspbian using `apt`
- Run `sudo raspi-config` to:
    - Change password of user `pi`
    - Change hostname
    - Set localisation options (locale, timezone etc.)
- Create my own user and give him `sudo` rights
- Harden SSH server config (different port and no root login)
- Enforce password request when sudoing (for user `pi`, see `/etc/sudo/sudoers.d/010_pi-nopasswd`, change `NOPASSWD` to `PASSWD`)
- Install [`ufw`](https://wiki.ubuntu.com/UncomplicatedFirewall) and allow SSH on the chosen port

It's important to test certain changes (firewall, SSH config changes) first by keeping the current terminal session and logging in a second time.
Otherwise, you might lock yourself out.

## Setting Up an External Drive

As mentioned in the introduction, I want to keep the data on an external drive connected via USB3.
Personally, I bought an SSD and put it in an enclosure.
The first step is to plug the drive into the USB3 port of the Raspberry Pi.
The USB3 ports are in the middle with blue inside.

### Find out the device name

Next, you need to find out the device name for the disk.
It usually starts with `/dev/sd<letter>`.
If it is the first one it is most likely `/dev/sda`.
To find out, execute `sudo fdisk -l` to get a listing of all devices.

### Create a partition table

First, you need to create a partition table (if none exists yet) and partition on the disk.
The steps here assume a single partition.
Execute `sudo fdisk /dev/<deviceName>` to enter the dialogue-driven program to manage the disk.
Then, do the following:

1. Create a new empty GPT partition table (press ++g++)
2. Create a new partition (press ++n++, and press enter for the following questions, i.e., use the defaults)
3. Save the changes (press ++w++)

The partition is identified by `/dev/<deviceName>1`.

### Create a filesystem for the partition

Now you can create a filesystem for this partition.
I suggest to use a Linux filesystem such as `ext4` (further reading about [Linux filesystems](https://opensource.com/article/18/4/ext4-filesystem)).
Execute `sudo mkfs.ext4 /dev/<deviceName>1 -L <label>` and wait until it is finished.

### Mount the partition

Now you can test to mount the partition.
First, create a directory where the partition should be mounted to.
Common places are in `/mnt` or `/media` (that's a personal choice): `sudo mkdir /mnt/mydisk`.
Then, try to mount it manually: `sudo mount /dev/<deviceName>1 /mnt/mydisk`.
If it succeeded, you can navigate to the folder and start using your disk.
You can also verify it by executing `mount -l` which outputs a list of all mounts.
To unmount, use `sudo umount` and add the directory or device name.

### Automatically mount a disk on boot

To automatically mount a disk on boot, an entry in the [fstab](https://wiki.debian.org/fstab) file is required.
First, find out the `PARTUUID` of the partition:

```shell
sudo blkid
```

Then, edit the fstab file (`sudo nano /etc/fstab`) and add the following entry (adjust options as needed):

```shell
PARTUUID=<partUUID> /mnt/<dir>    ext4    defaults,auto,rw,nofail,noatime    0  2
```

Now, reboot the Raspberry Pi and the drive should already be mounted.
The official Raspberry Pi Documentation also has a page about [external storage](https://www.raspberrypi.com/documentation/computers/configuration.html#external-storage).

NOTE: **`fstab` entry options**
At the beginning I also had `user` as an option to allow users to mount.
However, this implies `noexec` which prevents binaries from being executed on this filesystem.
This caused a problem with _Gitea_ because the [commit hooks of repositories couldn't be executed](https://github.com/go-gitea/gitea/issues/9365).
You can of course add `exec` as well, but since I don't need users to mount I just removed `user` instead.

### Dealing with slow speeds and other USB storage related issues

At first I thought everything works fine, until I moved the _MariaDB_ data directory to this external disk (see below) and rebooted.
_MariaDB_ wouldn't start and eventually timed out.
Through a coincidence (when my disk would start unmounting randomly and having I/O errors) I found out that there is a problem with [UAS](https://en.wikipedia.org/wiki/USB_Attached_SCSI) support on the [Raspberry Pi 4 causing slow speeds](https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=245931).
It's not quite clear to me currently whether this is an issue with the enclosures or the Raspberry Pi.

*[UAS]: USB Attached SCSI or USB Attached SCSI Protocol (UASP)

It turned out that the speed was actually really slow (~20 MB/s for sequential write).
I had only tested the enclosure when attached to my Mac.
Following the [steps to enable quirks mode](https://forums.raspberrypi.com/viewtopic.php?f=28&t=245931#p1501426) for the disk fixed this issue.
While the speeds are now higher (~210 MB/s) they are not as high as they could be with UAS (~430 MB/s).
But it resolved the problem with MariaDB (and other services requiring the mounted disk).

There are some additional resources with a list of [known adapters that work](https://jamesachambers.com/raspberry-pi-4-usb-boot-config-guide-for-ssd-flash-drives/), and a [benchmarking script](https://jamesachambers.com/raspberry-pi-storage-benchmarks-2019-benchmarking-script/) to benchmark the drive (with the adapter).

If you simply would like to test the sequential write and read speeds you can use the following commands:

```shell
# write
time dd if=/dev/zero bs=1024k of=tstfile count=1024 2>&1
# read
time dd if=tstfile bs=2048k of=/dev/null count=8192 2>&1
```

### Moving MariaDB data directory to external storage

With using the external disk I thought it makes sense to store pretty much everything (besides the system) on the external storage.
Somewhere I also came across a comment about extending the life of the Micro SD card if the database is not on there, but I don't know how valid this is.
I assume it could be due to a lot of writes.

Moving the MariaDB data directory is quite simple:

1. Stop the service:

    ```shell
    sudo systemctl stop mariadb
    ```

2. Copy the data directory:

    ```shell
    sudo cp -R -p /var/lib/mysql /mnt/mydisk/
    ```

3. Change `datadir` under `[mysqld]` in `/etc/mysql/mariadb.conf.d/50-server.conf` to the new location

4. Start the service again:

    ```shell
    sudo systemctl start mariadb
    ```

If everything goes well (verify with `sudo systemctl status mariadb`) you can remove the old data directory.

### Ensure MariaDB starts after disk is mounted

When you reboot it is possible that MariaDB won't start if the external disk has not been mounted yet at the time MariaDB starts.
Even if it did, there is no guarantee that it works for every system startup.

To address this you can make the MariaDB service _depend_ on the mount service ([a service for the _fstab_ mounts is generated](https://unix.stackexchange.com/a/247547)).

WARNING:
The service file you see shown at the top of the output of `systemctl status` gets overwritten on package upgrades.
Don't edit it directly.

Create an override file for the _MariaDB_ service.
The required directory probably does not exist yet:

```shell
sudo mkdir /etc/systemd/system/mariadb.service.d
```

Create the file `mount.conf` in this directory with the `[Unit]` section.
Add `RequiresMountsFor=/mnt/mydisk`.

NOTE:
The corresponding dependencies ([After](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Before=) and [Requires](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Requires=)) for [RequiresMountsFor](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#RequiresMountsFor=) will automatically be generated.

The resulting file should look like this:

```systemd title="/etc/systemd/system/mariadb.service.d/mount.conf"
[Unit]
RequiresMountsFor=/mnt/mydisk
```

Reload the `systemd` daemon:

```shell
sudo systemctl daemon-reload
```

Now, reboot the system and MariaDB should be active.
You can verify this using `systemctl`:

```shell
sudo systemctl status mariadb
```

## Pi-Hole

In terms of _Pi-Hole_ there is not much to document.
The installation and setup is very simple.
Depending on your router you might need to delegate the DHCP server to _Pi-Hole_.
I had to do this because the router I used first did not allow to set a DNS server for DHCP clients.
It only allowed to set global DNS servers which means that if _Pi-Hole_ is unavailable it cannot fall back to another DNS server (like your provider's DNS server).

### Change Pi-Hole web interface server port and hostname

By default, _Pi-Hole_ runs a `lighttpd` server on port `80`.
If you want to change this, add the following line to `/etc/lighttpd/external.conf`:

```lighttpd title="/etc/lighttpd/lighttpd.conf"
server.port := 8080
```

> OPTIONAL: **Changing the hostname**
> If you also want to make Pi-Hole available under a different hostname (e.g., through the use of a reverse proxy), there is another change you need to do in order for the automatic redirect to the admin interface to work.
> Add the following line to `external.conf`:
>
> ```lighttpd
> setenv.add-environment = ("virtual_host" => "pihole.domain.tld")
> ```

Then restart the `lighttpd` service using `systemctl`:

```shell
sudo systemctl restart lighttpd
```

Prior versions of _Pi-Hole_ could not handle using a different port and/or hostname on the admin site.
My [pull request](https://github.com/pi-hole/pi-hole/pull/3263) addressed these problems and is available with Pi-hole `v5+`.

### Custom hostnames inside network

Starting with _Pi-hole_ `v5` there is an option called _Local DNS Records_ that lets you do this easily using the admin interface.

The alternative described in the following paragraph is left for transparency.

I'll get to this later in [another post about the reverse proxy](./notes-on-traefik-v2-nextcloud-etc.md) but if you want to have custom hosts in your network, the easiest option I find is to edit the hosts file (`/etc/hosts`).
Add an entry there and execute `pihole restartdns`.

Now a `dig custom.host.name` should return the IP address of your server.

> UPDATES: **Updates to this blog post**
>
> - **24.05.2020:** Updated Pi-hole sections with changes introduced in Pi-hole v5.
> - **22.10.2024:** Improved section ensuring the _MariaDB_ service starts after the disk is mounted:
>     Custom unit file so that changes don't get overwritten on package upgrades.
