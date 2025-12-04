---
categories:
  - Linux
date:
  created: 2025-04-04
---

# Installing Debian on a Server with Partitions using LVM

The last virtual server (vServer) I had had limited storage space and *Docker* kept filling up my `/var/lib/` directory.
A friend suggested to use `lvm` to partition the disk.
Here is how I accomplished it using the *Debian* installer.

<!-- more -->

??? note "netcup specific preparation"

    My server is hosted by [netcup](https://www.netcup.com) so the following is specific to their server control panel (SCP).

    1. Log in to the SCP and choose the server
    2. Select *Steuerung*
    3. Stop the server with *Herunterfahren (ACPI)*
    4. Then, select *Medien* > *DVD Laufwerk*
    5. Under *Offizielle DVDs* select the *Debian* option
        - Enable *Bootmodus auf DVD setzen* and enter the SCP password
        - Then, select *DVD einlegen*
    6. Go back to *Steuerung* and start the server
    7. Once started, go to *Allgemein* and on the top right click on the VNC image to open the VNC popup

    At the end of the installation, eject the DVD and reboot the system.

Once you see the first screen of the *Debian* installer, follow these steps:

1. Select *Install* and follow the instructions
2. When asked for the partitioning method: Choose *Manual*
3. At the next screen, choose *Guided Partitioning*
4. Select the disk, then *All files in one partition* as the partitioning scheme
5. Agree to the changes and then choose the size of the root partition, e.g., `50 GB`
6. At the next screen, choose *Configure the Logical Volume Manager*
7. Now, use *Create Logical Volume* to create additional volumes and their sizes that you want
    - Don't assign all the free space to give you the ability to extend volumes later as necessary
    - `data`: 100 GB
    - `var`: 50 GB
    - `home`: 10 GB
8. Then select *Finish*
9. In *Partition Disks*, select the new volumes to configure them
    - Under *Use as* choose *Ext4 journaling file system*
    - Then define the mount point
10. Once you are done, select *Finish partitioning and write changes to disk*
11. The installation will now continue: When asked for the software to be installed, make sure only *SSH server* and standard system utilities are selected

Once the system is rebooted you should be able to log in via SSH.
It seems that root login via SSH is disabled by default, so log in with the user that you chose during the installation.

When you are logged in, you can switch to `root` via `su -`. (1)
{ .annotate }

1. Don't just use `su` since you will be missing the correct `$PATH`.
    See this comment explaining it: https://www.reddit.com/r/linuxquestions/comments/pcfjo6/comment/haijm8f/

The filesystem looks something like this at the end:

```shell
$ df -h
Filesystem                    Size  Used Avail Use% Mounted on
udev                          3.9G     0  3.9G   0% /dev
tmpfs                         794M  680K  793M   1% /run
/dev/mapper/mattsch--vg-root   45G  1.3G   42G   3% /
tmpfs                         3.9G     0  3.9G   0% /dev/shm
tmpfs                         5.0M     0  5.0M   0% /run/lock
/dev/vda2                     456M  138M  294M  32% /boot
/dev/mapper/mattsch--vg-home  9.1G   52K  8.6G   1% /home
/dev/mapper/mattsch--vg-data   92G   24K   87G   1% /data
/dev/mapper/mattsch--vg-var    46G  265M   43G   1% /var
/dev/vda1                     512M  6.1M  506M   2% /boot/efi
tmpfs                         794M     0  794M   0% /run/user/1000
```

You can then go ahead and change passwords, and configure things.
Take a look at the post [setting up Debian](../2021/set-up-debian.md) on how I set up my Debian server.
