---
migrated: true
date:
  created: 2018-07-25
  updated: 2023-05-28
categories:
  - Firefox
slug: digging-into-the-firefox-ui-for-the-tab-close-button
---

# Digging into the Firefox UI for the tab close button

Last year a new Firefox version broke the ["close button on tab hover" tweak](../2016/firefox-close-tab-button-on-hover.md) and I mentioned I will write a separate blog post on how I found out why and how to fix it.
Life happened, but fortunately I wrote down bullet points about what I did.

It seems that with Firefox 54 something in the UI changed which broke the functionality.
Fortunately, it wasn't the removal of the ability to customize the UI using `userChrome.css`.
In order to find out why the CSS selector didn't work anymore, it was necessary to see how a tab was structured in XUL.

A while ago I used [DOM Inspector](https://web.archive.org/web/20181122221742/https://addons.mozilla.org/en-US/firefox/addon/dom-inspector-6622/) which now is a legacy extension.
The Firefox version at the time was 57, but it didn't allow legacy extensions anymore.
So I went back to the last 54.x version, which allowed the installation of this "legacy" extension.
Unfortunately, I could not open its UI.
I did however find the extension [InspectorWidget](https://web.archive.org/web/20181102004227/https://addons.mozilla.org/en-US/firefox/addon/inspectorwidget/).
It has a nifty shortcut to open the inspector for the desired element right away.
Hold ++ctrl+shift++ while clicking on the desired UI element.

Using the inspector I found out that there was a new CSS rule that set `display: none` for certain elements, one of them being the close button for tabs.
To find out the initial/default value I used the computed rules, which showed `-moz-box`.
This allowed to add `display: -moz-box !important` to the rule for hovered tabs to make it work again.

While it doesn't seem possible to inspect the UI anymore with "Firefox Quantum" due to the introduction of _WebExtensions_, the CSS rules still work.
However, it is unclear whether these kind of UI customizations will stay.
There seemed to be [plans to remove](https://blog.mozilla.org/addons/2017/02/16/the-road-to-firefox-57-compatibility-milestones/comment-page-1/#comment-223635) it but perhaps they realized how many users are using this to tweak their UI since extensions are not allowed to do it anymore.
This [bug report](https://bugzilla.mozilla.org/show_bug.cgi?id=1416044) to collect usage of `userChrome.css` supports this theory.

**Update (2023):** In the last few years there has been a much easier (built-in) way to inspect the Firefox UI using the _Browser Toolbox_.
See [this post on Super User](https://superuser.com/a/1608642).
