---
migrated: true
date:
  created: 2018-09-12
  updated: 2018-09-12
categories:
#   - Frameworks
#   - Hints
  - Web Development
slug: deploying-angular-application-on-apache-server
---

# Deploying Angular application on Apache server

If you need to deploy an Angular application on a server running Apache, and are making use of [routing for navigation](https://angular.io/guide/router), you can't just upload the built application onto the server and be done with it.
As soon as you navigate to another path, the Apache server will try to look for that resource on the server and most likely will give you an `404 Not Found` error.

You need to rewrite all the URLs to the `index.html` so that the Angular application can take care of it.
Your server needs to support `mod_rewrite` for that.
If that is the case, you can upload a `.htaccess` file with the following content to your directory where the Angular application resides in:

```apacheconf
RewriteEngine on
RewriteBase /

RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_URI} !^/assets/(.+)$
RewriteRule ^(.+)$ index.html?path=$1 [L]
```

This will rewrite all requests to the `index.html` file and append any extra path to it.
Unless, the request is for an existing file or directory on the server, then it will not rewrite it.
This is necessary for the additional resources that will need to be loaded, such as CSS and JS files and images.

In order to get the necessary feedback when a resource is requested that does not exist, the third condition excludes to rewrite any request located inside the assets folder.
