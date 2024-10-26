---
migrated: true
date:
  created: 2013-04-25
  updated: 2017-12-12
# categories:
#   - Howto
#   - Mac OS
slug: reducing-file-size-of-a-pdf-on-mac-os
---
# Reducing file size of a PDF on Mac OS

The file size of PDFs can become quite large, especially when scanning documents or documents containing images.
Instead of sending large files, it is almost always recommended to reduce the file size.
To do that, there are several ways.
For example, there is an app called [_PDF Squeezer_](https://apps.apple.com/de/app/pdf-squeezer-4/id1502111349?l=en-GB&mt=12 "PDF Squeezer") in the _Mac App Store_ (in 2013: €3.59 or $3.99, more expensive today).

The same functionality can be achieved using _Quartz filters_ in the _ColorSync Utility_. There is already one called _Reduce File Size_ but it might lead to a blurry PDF.
You can copy this filter and adjust the settings.
However, I found custom filters in the [Apple Support Community](https://discussions.apple.com/message/21402148#21402148 "Apple Support Community") that work quite well.

* [Download the filters](https://github.com/joshcarr/Apple-Quartz-Filters "Download Quartz filters to reduce file size of PDFs")
* Move the filters to `~/Library/Filters`
* Open your PDF with _ColorSync Utility_
* In the bottom, choose the appropriate filter.
There are several options starting with "_Reduce to ..._"
* Click "Apply"
* If you are satisfied with the result, save the file under a different file name (_File > Save As_).

Alternatively, you can place them into `/Library/PDF Services/` instead.
Besides the fact that the filters will be available to all system users, when exporting PDFs in _Preview_, you can select a filter directly in the dropdown under _Quartz Filters_.

If the filters don't work perfectly for your use, you can adjust the settings within the _ColorSync Utility_.

The original creator of the filters to be credited seems to be Jerome Colas according to this [GitHub repository](https://github.com/joshcarr/Apple-Quartz-Filters).

> UPDATES: **Updates to this blog post**
>
> * **December 2017:** Uploaded the ZIP file to my own server, since the original link became unavailable.
> * **27.10.2024:** Replaced ZIP file with link to GitHub repository to download filters
