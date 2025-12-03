---
migrated: true
date:
  created: 2015-08-19
  updated: 2015-08-19
tags:
  - archived
  - java
  - open source
slug: mt4j-with-processing-2
---

# MT4j with Processing 2

--8<-- "docs/snippets/archive.md"

In our [TouchCORE](https://djeminy.github.io/touchcore/) project at the [Software Engineering Lab](https://www.cs.mcgill.ca/~joerg/SEL/SEL_Home.html) at McGill University, we use [MT4j](https://www.mt4j.org) (Multitouch for Java) for the multitouch-enabled user interface.

For a long time, we had the problem that we couldn't run it on OSX using Java 7 and newer, because it is based on an older version of [Processing](https://processing.org) (`1.x`), which in turn uses an old version of [JOGL](https://jogamp.org/jogl/www/) (Java Binding for the OpenGL API).
That version is only compatible with the Java supplied by Apple.
As we know, they stopped support with Java 6.

We begrudgingly lived with this state for a long time, which meant that OSX users needed to download and use an old version of Java.
Now, with the new release of [Eclipse Mars](https://eclipse.org/), support for Java 6 was dropped, i.e., Java 7 or greater is required.
We wanted to update to _Mars_, and since we use some Eclipse plugins, such as the [Eclipse Modeling Framework (EMF)](https://eclipse.org/modeling/emf), we needed to use at least Java 7.

This finally pushed us to update _MT4j_ ourselves.
With the help of the [UltraCom](https://github.com/lodsb/UltraCom/tree/proc2) project who did the same but added a ton of other stuff.
Based on their commits we managed to update it on our copy (which already had some minor improvements) of MT4j's last official release `v0.98`.

We put it up on GitHub so hopefully other people can benefit from it: https://github.com/mschoettle/mt4j
