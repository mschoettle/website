---
categories:
  - Projects
date:
  created: 2024-12-17
  updated: 2025-12-23
links:
  - blog/posts/2025/migrate-wordpress-posts-markdown.md
tags:
  - migration
  - open source
  - projects
  - self hosting
---

# Blog Relaunched

My blog has existed since 2011.
The intent has always been to share knowledge I gained, whether this be for someone else, or just for my future self.
From the beginning I used [Wordpress](https://wordpress.org) which makes it quite easy to set up a blog.
There are also tons of [themes](https://wordpress.org/themes/) and [plugins](https://wordpress.org/plugins/) that you can install and use.

Writing (especially in public) is not super natural for me.
Doing it in _WordPress_ did not feel natural to me either.
So for a while I was dredding to create new blog posts because it was too cumbersome for me multiple reasons.

Another difficulty was keeping WordPress up to date along with the plugins and any customizations to it.
While it is fairly easy to customize CSS, JS, or the PHP code of themes and plugins, there is no easy way to keep those separate so that themes and plugins can be easily updated.

I switched to a containerized setup, putting as much as possible in a repository.
This included customizations.
My idea was that it would be easier to update themes and plugins and re-apply those customizations.
In the end, it was still too much manual work, however.
It's not as easy as merging a dependency update on your repository raised by [Renovate](https://docs.renovatebot.com) (of which I am a huge fan) and automatically re-deploying.

A few years ago, I came across the amazing [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).
It is a technical documentation theme for [MkDocs](https://www.mkdocs.org/) with many great features.
Documentation is written in Markdown and can be version controlled in a repository.
This is basically "documentation as code".

I first introduced it at [work](../../../projects/index.md#opal) a few years ago for various documentation sites.
Together with _Material for MkDocs_ this has been fantastic.

Since _Material for MkDocs_ has a [blog plugin](https://squidfunk.github.io/mkdocs-material/plugins/blog/) I've been wanting to switch to this for a while.
I knew that this will allow me to write blog posts more naturally (in a text editor) and treat everything as code.
I finally got around to it and migrated my old WordPress site to what is now a static site.

It is live now :smile:.

Keep reading if you are interested in the details of how it is set up.

<!-- more -->

In a follow-up post I wrote about the process of [migrating Wordpress posts to Markdown](../2025/migrate-wordpress-posts-markdown.md).
