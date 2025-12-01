---
migrated: true
date:
  created: 2015-11-10
  updated: 2015-11-10
categories:
#   - Mac OS
  - Thunderbird
slug: thunderbird-extension-hide-badge-icon
---

# Thunderbird Extension: Hide Badge Icon

--8<-- "docs/snippets/archive.md"

About two years ago (a few months after switching to Mac OSX) I noticed that the badge on the Thunderbird app icon is quite distracting for me while I work (it notifies about new and how many emails were received).
As soon as it pops up I would notice it and felt an urge to immediately check what the new email is about.
Then of course, the current focus and concentration is lost.

I wanted to turn the badge of, as this is generally supported on OSX.
However, I found out that this is not the case with Thunderbird.

NOTE: This functionality is supported natively with newer versions of Thunderbird.

I didn't give up easily and went to search the _Internet_.
Unfortunately, no one had attempted this, complained about it or filed a bug report.
Also, I could not find any documentation about this on the Thunderbird pages.

I wanted to know more and started digging into the [source code of Thunderbird](https://hg.mozilla.org/comm-central/).
An advantage of open source software.
Because this is a Mac OSX specific thing, searching for files related to OSX seemed logical.
Eventually, I found the file `nsMessengerOSXIntegration.cpp` (it is now [`nsMessengerOSXIntegration.mm`](https://hg.mozilla.org/comm-central/file/f213d36d9e16b3cf58b1a8e475e116a3fc6b08af/mailnews/base/src/nsMessengerOSXIntegration.mm)) where the logic for this functionality is implemented.
While I did find an interesting [piece of code](https://hg.mozilla.org/comm-central/file/f213d36d9e16b3cf58b1a8e475e116a3fc6b08af/mailnews/base/src/nsMessengerOSXIntegration.mm#l555), the revisions also were helpful, which led me to [bug report #274688](https://bugzilla.mozilla.org/show_bug.cgi?id=274688).
In this bug report a hook was introduced which allows to observe a property called `before-unread-count-display`.
Upon notification, the desired badge label can be modified/adjusted (e.g., making 100+ for all counts greater than 100) before it is displayed.
If an empty string is returned, however, the badge will be hidden.

And that was it.
I digged into it and found an (unfortunately) undocumented extension feature.
This allowed me to write an extension with the purpose of hiding the badge in all situations.
I have actually used it for more than two years.
My intention was always to release it and share it with others, but kind of put it off.
Since I was updating [my other extension](thunderbird-extension-toggle-headers-updated.md) anyway, I finally did it.

To my surprise, it was fully reviewed without any complaints right away.
So if you want to work without distractions, you can now use [Hide Badge Icon](https://addons.thunderbird.net/thunderbird/addon/hide-badge-icon/) to hide the badge of the Thunderbird app icon.
