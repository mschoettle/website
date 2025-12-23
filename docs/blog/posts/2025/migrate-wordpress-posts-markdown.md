---
categories:
  - Projects
date:
  created: 2025-12-09
tags:
  - automation
  - migration
  - python
  - self-hosting
  - wordpress
---

# Migrating Wordpress posts to Markdown

Last year (2024) I [relaunched my website](../2024/blog-relaunched.md) and I promised to write about the migration process.
This post describes how I migrated the posts of my blog to Markdown, automating as much as possible.

<!-- more -->

My main interest in automating the migration was my blog posts.
In addition, I also migrated project descriptions coming from a project plugin[^1].

The first step is to export a backup of the site.
WordPress can export all posts in one XML file.
The process is [documented](https://learn.wordpress.org/lesson/tools-export-and-import/#:~:text=another%20WordPress%20site.-,exporting,-If%20you%20are) and is fairly straightforward:

1. Log in as an admin
2. Go to Tools > Export
3. Select what you want to export, you can select "All content"
4. Click "Download Export File"

- wrote a script to automate this process
- the XML contains a lot of information
- since I didn't have many pages, focussed on the blog posts and projects
    - first just the posts (excluding other types of posts)

[^1]: I used the [Portfolio and Projects plugin](https://wordpress.org/plugins/portfolio-and-projects/) to showcase some of my work.
    The plugin uses a custom post type for projects that are then arranged on a dedicated page.
