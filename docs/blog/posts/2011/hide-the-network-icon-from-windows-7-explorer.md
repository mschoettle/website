---
migrated: true
date:
  created: 2011-03-30
  updated: 2024-10-16
categories:
  - Tweaks
  - Windows
slug: hide-the-network-icon-from-windows-7-explorer
---
# Hide the "Network" icon from Windows 7 Explorer

If you want to hide the "Network" icon from the sidebar of the Windows Explorer in Windows 7 you can do this by modifying the registry.
In order to be able to do this you have to be logged in as an Administrator.
Despite that you'll have to give yourself the permissions to change the value.
You can remove the permissions after you are done again.

> [!CAUTION]
> Please be aware that you should [back up the registry](https://www.bleepingcomputer.com/tutorials/how-to-backup-and-restore-the-windows-registry/Back-up-the-registry "Back up the registry") before making any modifications.
> At least the key you will modify.

In the registry go to the following key `HKEY_CLASSES_ROOT\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder\` and change the value of `Attributes` from `b0040064` to `b0940064`. ([Source](https://social.technet.microsoft.com/Forums/en-US/w7itproui/thread/a78d5dfb-4b19-4f25-b220-5bcecfc06ac4#4c1b605b-f1c5-45db-bb62-21d045987fe1))

> [!IMPORTANT]
> **Note:** The network environment will still be accessible.
> It will not restrict access to it using other ways.
