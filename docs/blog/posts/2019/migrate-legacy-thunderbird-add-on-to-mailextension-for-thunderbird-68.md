---
migrated: true
date:
  created: 2019-12-11
  updated: 2019-12-11
categories:
  - Thunderbird
slug: migrate-legacy-thunderbird-add-on-to-mailextension-for-thunderbird-68
---
# Migrate (Legacy) Thunderbird add-on to MailExtension for Thunderbird 68

Like with Firefox, Thunderbird is also changing add-ons to _WebExtensions_ (called _MailExtension_ there). [Thunderbird 68](https://www.thunderbird.net/en-US/thunderbird/68.0/releasenotes/) introduced this requirement.
Users on older versions still are not offered the latest version through the automatic updater so it stayed below my radar.

Recently, some users of my [Toggle Headers extension](../2015/thunderbird-extension-toggle-headers-updated.md) reached out to me asking whether I intend to update it for Thunderbird 68 and later.
I finally got a chance to migrate it and it was fairly easy in my case.

The easiest way is to convert it to a [MailExtension with legacy support](https://developer.thunderbird.net/add-ons/tb68) that allows to keep the old XUL stuff.
The main changes I had to do were:

* Replace `install.rdf` with `manifest.json`:
This is really straightforward given the [documentation](https://developer.thunderbird.net/add-ons/updating/historical-overview/overlays#switch-to-json-manifest)
* Add a `legacy` key to the manifest.
    Some examples showed `"legacy": true` but that did not work.
    Instead, you need to specify:

    ```json
    "legacy": {
        "type": "xul"
    }
    ```

* In the `chrome.manifest` I had overlaid `mailWindowOverlay.xul`.
This had to be changed to `messenger.xul`.
See the [note on overlaying](https://developer.thunderbird.net/add-ons/updating/historical-overview/overlays#notes-about-overlaying-in-general).

With this, the extension can be packaged up (now with a nice little ant build script that automates this) and uploaded to Thunderbird's add-ons site.
Luckily, there it passed the review with no complaints and [version 2.0](https://addons.thunderbird.net/en-US/thunderbird/addon/toggle-headers/versions/2.0) is now available.

I think it should be possible to accomplish this without any old XUL stuff.
There is a [MailExtension API documentation](https://webextension-api.thunderbird.net/en/stable/) that outlines [`commands`](https://webextension-api.thunderbird.net/en/stable/commands.html).
Since users mainly use the add-on for the convenient key shortcut (++h++) this seems feasible.
But that's for another day :sweat_smile:.
