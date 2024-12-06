---
migrated: true
date:
  created: 2012-02-07
  updated: 2012-02-07
categories:
  - Thunderbird
slug: thunderbird-extension-toggle-headers
---
# Thunderbird Extension: Toggle Headers

After updating my Thunderbird to the current version there was one extension not working anymore: [Headers Toggle](https://addons.mozilla.org/thunderbird/addon/headers-toggle/).
Even manually adjusting `maxVersion` in the `install.RDF` to pretend it's compatible didn't work.
This extension allowed you to switch the headers view between seeing all headers (All) and the most important header information (Normal) with a single key shortcut ++h++.
Unfortunately this extension hasn't been updated in a long time.

I created a new Thunderbird extension called [Toggle Headers](https://addons.thunderbird.net/thunderbird/addon/toggle-headers/) that allows you to do this and works with the current (and upcoming) Thunderbird version.

**Update:** The newest version (`0.3`) of [Toggle Headers](https://addons.thunderbird.net/thunderbird/addon/toggle-headers/)  is compatible with _CompactHeaders_.
When both are used at the same time the current state of the headers view is taken into account:

* when collapsed and ++h++ is pressed, the headers view will be expanded and all headers shown
* pressing ++h++ again will switch back to the normal headers view but also collapse the view again (the previous state is remembered)
