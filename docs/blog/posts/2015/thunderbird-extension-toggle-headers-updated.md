---
migrated: true
date:
  created: 2015-11-10
  updated: 2015-11-10
categories:
  - Thunderbird
slug: thunderbird-extension-toggle-headers-updated
---
# Thunderbird Extension: Toggle Headers Updated

My Thunderbird extension [Toggle Headers](../2012/thunderbird-extension-toggle-headers.md) was running smoothly for a long time.
It only needed to be kept aligned with the Thunderbird version updates (for the maximum supported version of the extension).
Everything was fine until the third-party extension [CompactHeader](https://addons.thunderbird.net/thunderbird/addon/compactheader/?src=ss), which is supported by _Toggle Headers_, released a new version with internal changes.
These changes involved some refactoring, which meant the function to toggle between the compact and expanded header pane had a different name (or namespace).

The way I noticed this, since I don't use _CompactHeader_ myself, was by receiving a 1-star review.
Of course, no proud developer likes this.
Generally, I prefer to be contacted directly with bug reports and be able to respond before receiving a review.
If a developer doesn't respond, a bad review is then acceptable.
However, in this case bad reviews could be turned into very good ones, so no complaints in the end :smile:.

Long story short, a new version of Toggle Headers was released.
Basically, [Toggle Headers v1.0](https://addons.thunderbird.net/thunderbird/addon/toggle-headers/) restores support for _CompactHeader 2.1.0_ and higher, but at the same time, it still works with older versions.
Unfortunately, the new version of _CompactHeader_ contains a bug that prevents toggling between the header modes (_Normal_/_All_) to work properly.
I [reported the bug](https://forums.mozillazine.org/viewtopic.php?p=14375693#p14375693) in the referenced support forums, but haven't received a response to date.

This required a workaround to be integrated into the new version.
When switching from collapsed header pane and _Normal_ to _All_ headers and then back to _Normal_, the header pane would stay expanded.
The _Compact_ option however is checked in the menu.
The workaround simply disables and enables the compact header again to make it work until a fixed version gets released.

The same kind of story happened with another extension.
An extension I never heard of named _Phoenity Buttons_ made my extension not work anymore.
This was due to the usage of the same key shortcut (++h++).
Somehow Thunderbird gave precedence for the key binding to that extension.
Fortunately, the developer of this extension was very helpful and even willing to change his key binding to another one :thumbsup:.

All in all, a great experience with the Thunderbird extension and user community.
