---
migrated: true
date:
  created: 2012-05-10
  updated: 2012-05-10
tags:
  - archived
  - subversion
  - tips
  - windows
slug: using-multiple-svn-clients-with-the-svnssh-protocol-and-a-putty-profile
---

# Using multiple SVN clients with the `svn+ssh` protocol and a putty profile

--8<-- "docs/snippets/archive.md"

When trying to access an SVN repository using the `svn+ssh` protocol with _TortoiseSVN_ it might happen that the password prompt shows up endless times.
One suggested solution is to set up a profile in _putty_ and use a private key for authentication for SSH there.
Then in _TortoiseSVN_ the host name just has to be changed to the name of the profile, e.g., `svn+ssh://username@puttyProfileName/path/to/repo`.

This works well until trying to reuse the stored SVN information of your local working copy in another client, for example your IDE.
In my case I am using _Eclipse_ with the _Subclipse_ plug-in, and my first approach didn't work with _Subclipse_.
This meant I couldn't do any team actions from within _Eclipse_ when the projects where checked out using _TortoiseSVN_.
If you are only using either of them it works fine.

The solution is quite simple:
Rename the _putty_ profile to the actual hostname and use the regular URL for the repository.
That's it.
If you've used the _putty_ profile name before just use _relocate_ in _TortoiseSVN_ to change the repository URL.
_TortoiseSVN_ will then still use the _putty_ profile with the private key to authenticate.
Other clients like _Subclipse_ see it as an actual hostname and are able to use that.
