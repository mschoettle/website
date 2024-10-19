---
migrated: true
date:
  created: 2012-02-06
  updated: 2012-02-06
categories:
  - Thunderbird
  - Tweaks
slug: hide-star-besides-email-addresses-in-thunderbird
---
# Hide star besides email addresses in Thunderbird

If you&ndash;for some reason&ndash;don't like the yellow (for contacts in your address book) or gray (for unknown contacts) star next to email addresses in the message header there's a simple way on how to hide it.

If you don't have one yet, all it needs is a file called [userChrome.css](https://developer.mozilla.org/en/Thunderbird/Thunderbird_Configuration_Files#userChrome.css) inside a folder called `chrome` inside your profile folder. Add the following content:

```css
.emailStar {
    display: none !important;
}
```

If you ever want to see it again just delete those lines.
