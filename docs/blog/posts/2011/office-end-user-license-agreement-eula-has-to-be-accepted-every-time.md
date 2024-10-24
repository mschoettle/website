---
migrated: true
date:
  created: 2011-03-30
  updated: 2011-03-30
categories:
  - Office
slug: office-end-user-license-agreement-eula-has-to-be-accepted-every-time
---
# Office End-User License Agreement (EULA) has to be accepted every time

Do you have to accept the the End-User License Agreement (EULA) of your Office applications every time you start them even though you've accepted them already?
This might be because you are using a restricted user account and thus the change can't be written into the Windows registry.

To solve this, log in with an Administrator account and perform the following steps for all Office applications you are using:
Open the application, accept the EULA and close the application again.

If you log in with your user account again the EULA should not appear again.
If it doesn't work try to modify the permissions in the registry described in [this knowledge base article](https://support.microsoft.com/kb/884202).
