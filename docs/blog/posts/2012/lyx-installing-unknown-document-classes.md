---
migrated: true
date:
  created: 2012-05-28
  updated: 2012-05-28
categories:
  - Mac OS
slug: lyx-installing-unknown-document-classes
---
# LyX: Installing unknown document classes

If you either received a LyX file that uses a document class unknown to your LyX installation or you would like to create a document using one of the options in the settings dialog, you need to install that document class.

This description is for Mac OS based on the latest version of _MacTeX_ (as of May 28th 2012 this is _MacTeX-2011_), but should work with any version.

<!-- more -->

First, you should find out where the document class package should be put.
In a previous version, I mentioned to put it in `/usr/local/texlive/<version>/texmf-dist/tex/latex/` but this approach is not recommended, because it makes it only available for the current version.
There are two better options that allow you to install a new version and keep all your custom packages:
You can either make it available to all users or just your user.

* All users: `/usr/local/texlive/texmf-local/tex/latex/`
* Just you: Run `kpsewhich -var-value=TEXMFHOME` in _Terminal_.
This will show you your personal _TEXMF_ home directory (e.g., `~/Library/texmf`).
In case it doesn't exist, you need to create it, as well as the sub-directories, to get the path `~/Library/texmf/tex/latex/`.

Now that you know where to put it, follow these steps:

1. Download the desired document class package.
2. Put the folder with the downloaded document class package into the path retrieved above.
   You can use _Finder_ to do that.
   In _Finder_ go to _Go > Go to Folder_ and type in the path.
   You need to authenticate yourself in order to do that.
3. In _Terminal_ execute the following command: `sudo texhash`
You will be required to enter your password.
In case _texhash_ cannot be found you have to go to `/usr/local/texlive/<version>/texmf-dist/bin/` and execute `sudo ./texhash`.
You can make sure it worked by executing `kpsewhich classname.cls` which will give you the path to that package class.
4. In LyX do _Reconfigure_ (in the menu bar _LyX > Reconfigure_)
5. Restart LyX and the document class should be available now

On Windows (using _MikTeX_) this should work quite easy using the _MikTeX Package Manager_.

**Update 28.03.2013:** Fixed path to LaTeX packages (Thanks, Mathias!)<br>
**Update 05.04.2013:** Updated description with better location for custom document classes.
