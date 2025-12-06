---
date:
  created: 2016-01-04
  updated: 2016-01-04
migrated: true
slug: ios-how-to-fix-or-change-voicemail-number
tags:
  - archived
  - howto
  - ios
  - tips
---

# iOS: How to fix/change Voicemail number

--8<-- "docs/snippets/archive.md"

Recently, a friend's voice mail button did not work anymore.
Upon calling the voice mail, an audio error message appeared saying that the voice mail is not available or cannot be reached (something like that).

Unfortunately, Apple does not want you to just change the associated voice mail phone number that is called when tapping on "Voicemail".

Fortunately, there is a shortcut:

1. Go to the phone's keypad
2. Dial `*#5005*86#` and "call it"
3. A phone number will appear, which is the one currently associated with the voice mail.
    Write this down just in case.
4. Now, call `*5005*86*<insertPhoneNumber>#` and replace the placeholder with your phone number, starting with the country code (1 in this case for North America).
    For example, `14381234567`.
5. The voice mail button should now work.

This approach worked on the TELUS network (using Koodo).
If it doesn't work for you, revert the phone number to the one written down in step 3 and contact your provider.

**Source:** [planken.org](https://planken.org/2011/08/iphone-cannot-connect-voicemail)
