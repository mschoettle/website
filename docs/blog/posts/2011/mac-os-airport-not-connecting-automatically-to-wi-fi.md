---
migrated: true
date:
  created: 2011-03-30
  updated: 2011-03-30
categories:
  - macOS
slug: mac-os-airport-not-connecting-automatically-to-wi-fi
---
# Mac OS: Airport not connecting automatically to Wi-Fi

A few weeks ago I helped a friend with an issue he had on an iMac with the Wi-Fi.
After a while AirPort stopped from connecting automatically to the Wi-Fi.
Although this can be caused by various different issues I want to describe the one I found.
All the other instructions can be easily found on the web with the search engine of your choice.

The Wi-Fi uses a hidden SSID which can cause problems, not in this case though.
Although it doesn't really increase the security (because there are tools you can use that reveal it) it can help on a social basis when people just shouldn't see that there is a Wi-Fi.

Anyways.
As a side note: There were two iMacs set up the same way.
One worked fine but the other didn't so something must have been different.
A lot of tips didn't help but they could help in your case.
In this case the problem was caused by the fact that the `SystemPreferences` application was moved out of it's original place.
After moving it back to the Application directory (`/Applications`) and restarting the machine it worked fine again.
I suspect this could cause more problems than the one described here.
