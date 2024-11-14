---
migrated: true
date:
  created: 2016-01-04
  updated: 2023-05-28
categories:
  - Firefox
#   - Howto
slug: firefox-close-tab-button-on-hover
pin: true
---
# Firefox close tab button on hover

There are probably extensions that allow to do that, however, this is not necessary as I will show in this post.
Maybe you've seen the functionality in Safari or just wondered why the close button for tabs in Firefox can't just always be there.
In Safari, the close button appears when hovering over the tab itself.

<!-- more -->

The following modification adds this functionality to Firefox.
You need to create a file called `userChrome.css` with the following content:

=== "Firefox v113 and later"

    ```css
    .tabbrowser-tab:not([selected]):not([pinned]):hover .tab-close-button {
        display: flex !important;
    }
    ```

=== "Firefox up to v112"

    ```css
    .tabbrowser-tab:not([selected]):not([pinned]) .tab-close-button {
        visibility: hidden !important;
        margin-left: -16px !important;
    }

    .tabbrowser-tab:not([selected]):not([pinned]):hover .tab-close-button {
        visibility: visible !important;
        margin-left: 0px !important;
        display: -moz-box !important;
    }
    ```

## Instructions

Place this file into the `chrome` folder inside your profile's directory.
Follow the [directions from Mozilla to find out where to find the profile's directory location](https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data).
If the `chrome` folder does not exist, you need to create it first.

<!-- markdownlint-disable-next-line max-one-sentence-per-line -->
>? NOTE: **Additional step for Firefox before `v113` only**
> In the address bar, open `about:config` and change the following preferences:
> `browser.tabs.tabClipWidth` to `99`

New versions of Firefox (`v69+`) don't load the `userChrome.css` on startup by default.
Make sure that `toolkit.legacyUserProfileCustomizations.stylesheets` is set to `true`.

Then just restart Firefox and you are done.

> UPDATES: **Updates to this blog post**
>
> * **Update 1:** I just tried this again myself due to a fresh installation and you also need to change the `browser.tabs.tabClipWidth` [preference](https://kb.mozillazine.org/About:config) from it's default value (`140`) to `99`.
> * **Update 2 (August 2017):** As pointed out by Veto in the comments, this functionality is broken since version `55.0.3`.
> The above CSS has been updated to stay compatible with the new Firefox UI.
> * **Update 3 (December 2017):** As pointed out in the comments, pinned tabs were affected too.
> Thanks to Mike for the solution on how this can be avoided.
> The above CSS has been adjusted.
> * **Update 4 (October 2019):** As pointed out in the comments, Firefox 69 by default doesn't load the `userChrome.css` anymore for new installations.
> * **Update 5 (May 2023):** I noticed recently that the close button on hover was not working anymore.
> I first noticed it on Firefox `v113` while on another machine with Firefox `v112` it was still working.
> The CSS rules in Firefox slightly changed.
> Added a new CSS rule for Firefox `v113+`.
> Also the clip width change is not necessary anymore.

**Original Source:** [Post on Neowin Forums](https://www.neowin.net/forum/topic/985580-firefox-tab-close-button-to-appear-when-you-hover-over-a-tab/?page=2)
