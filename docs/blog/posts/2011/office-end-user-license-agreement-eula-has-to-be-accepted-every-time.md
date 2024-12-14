---
migrated: true
date:
  created: 2011-03-30
  updated: 2011-03-30
# categories:
#   - Office
slug: office-end-user-license-agreement-eula-has-to-be-accepted-every-time
---
# Office End-User License Agreement (EULA) has to be accepted every time

--8<-- "docs/snippets/archive.md"

Do you have to accept the the End-User License Agreement (EULA) of your Office applications every time you start them even though you've accepted them already?

This might be because you are using a restricted user account and thus the change can't be written into the Windows registry.

To solve this, log in with an Administrator account and perform the following steps for all Office applications you are using:

1. Open the application,
2. accept the EULA, and
3. close the application again.

If you log in with your user account again the EULA should not appear.
If it doesn't work try to modify the permissions in the registry described in [this knowledge base article](https://learn.microsoft.com/en-us/office/troubleshoot/office-suite-issues/office-end-user-license-agreement).
