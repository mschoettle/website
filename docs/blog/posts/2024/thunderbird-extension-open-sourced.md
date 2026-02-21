---
categories:
  - Thunderbird
date: 2024-08-20
links:
  - Repository: https://github.com/mschoettle/toggle-headers
  - Add-on page: https://addons.thunderbird.net/thunderbird/addon/toggle-headers/
  - Previous blog posts:
      - blog/posts/2012/thunderbird-extension-toggle-headers.md
      - blog/posts/2015/thunderbird-extension-toggle-headers-updated.md
tags:
  - open source
  - thunderbird
---

# Open Sourced Toggle Headers Thunderbird extension

A long time ago I released the [Toggle Headers extension](../2012/thunderbird-extension-toggle-headers.md) for Thunderbird.
I've kept it in a private git repository all this time (it might have started in a Subversion repository even).

This was way before I really got into open source.
Recently, a member of the Thunderbirds Add-ons reviewer team sent in a fix and asked if I was willing to open source it to make contributions easier.

So I did [open source it](https://github.com/mschoettle/toggle-headers), and [added a PR to fix compatibility with newer Thunderbird versions](https://github.com/mschoettle/toggle-headers/pull/1).
I attributed this change to the reviewer who submitted the patch via email.

At the same time, it gave me a chance to create a script that allows me to build the add-on file.
I had used `ant` before but given that it is only a ZIP file [I wrote a small script in Python](https://github.com/mschoettle/toggle-headers/blob/main/build.py) which makes it a lot easier to run.

Even though I don't use Thunderbird currently anymore, I find it important to keep maintaining the add-on.
There are still a few users making use of it every day :smile:
