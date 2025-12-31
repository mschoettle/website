---
categories:
  - Projects
date:
  created: 2024-12-17
  updated: 2025-12-31
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

## Setup Details

In a follow-up post I wrote about the process of [migrating Wordpress posts to Markdown](../2025/migrate-wordpress-posts-markdown.md).

One of the decisions I made is that I will make the repository behind this website public.

### Project

This is the first project where I used [`uv`](https://docs.astral.sh/uv/) from the start and it's been great.

The project also uses ~~[pre-commit](https://pre-commit.com/)~~ [prek](https://prek.j178.dev/) with the following code quality tools as [pre-commit hooks](https://github.com/mschoettle/website/blob/main/.pre-commit-config.yaml):

- [`typos`](https://github.com/crate-ci/typos): A fast source code spell checker that also autocorrects typos.
- [`mdformat`](https://mdformat.readthedocs.io/en/stable/) with extensions: A great Markdown formatter.
- [`markdownlint-cli2`](https://github.com/DavidAnson/markdownlint-cli2): A Markdown linter.
    It is also used to enforce [semantic linebreaks](https://sembr.org)[^1].
- [`zizmor`](https://docs.zizmor.sh/): A static analysis tool for GitHub Actions that is very helpful to find various insecure uses.
- [`actionlint`](https://github.com/rhysd/actionlint) with `shellcheck` integration: Another static analysis tool for GitHub Actions that checks syntax, type checks etc.
    Using `shellcheck` it also lints scripts in `run:`.

!!! tip "Consider using `prek` as a replacement of `pre-commit`"

    I recently came across [`prek`](https://prek.j178.dev/) which is a new alternative for `pre-commit`.
    I've started using it and is much faster in installing the hooks.
    See the [Why prek?](https://prek.j178.dev/#why-prek) section for more information if you need more convincing.

Of course, I use [Renovate](https://docs.renovatebot.com) to update dependencies.
With some [presets and custom managers](https://github.com/mschoettle/website/blob/main/renovate.json5) it is possible to update all referenced versions across the whole code base.

Finally, I set up a CI workflow to ensure that everything that goes into `main` conforms to all the various checks.

### `mkdocs-material`

As mentioned above, I use _Material for MkDocs_.
The set up with `mkdocs-material` is pretty straightforward and mostly depends on personal preference.

Some of the additional plugins I used are:

- [Privacy](https://squidfunk.github.io/mkdocs-material/plugins/privacy/):
    This is a great plugin that automatically identifies and downloads external assets and downloads them during build to self-host them.

- [Tags](https://squidfunk.github.io/mkdocs-material/plugins/tags/):
    I only [recently added tags](https://github.com/mschoettle/website/pull/39).
    I found it better to put blog posts into one category (instead of multiple) and use tags instead.
    With [`mkdocs-material` v9.7.0](https://github.com/squidfunk/mkdocs-material/releases/tag/9.7.0) there were some tag-related features added that made me finally finish this.

- [Social](https://squidfunk.github.io/mkdocs-material/plugins/social/):
    This was only recently made available in the free version.
    I added the [social plugin with a custom layout](https://github.com/mschoettle/website/pull/172) for nice social cards when sharing a link of my website.

- [Optimize](https://squidfunk.github.io/mkdocs-material/plugins/optimize/):
    This was also only recently made available in the free version.
    I added it to optimize some images.

- [git-revision-date-localized](https://squidfunk.github.io/mkdocs-material/setup/adding-a-git-repository/#document-dates):
    I think it's helpful to show when (or how long ago) a page was last modified.
    I integrated [`git-revision-date-localized`](https://github.com/timvink/mkdocs-git-revision-date-localized-plugin) to do that.
    What was missing at the time was that the full timestamp is shown when hovering over the element.
    So I made contributions ([timestamp on hover](https://github.com/timvink/mkdocs-git-revision-date-localized-plugin/pull/152), [include timezone on hover](https://github.com/timvink/mkdocs-git-revision-date-localized-plugin/pull/175)) to support that :material-party-popper:

- [markdown-callouts](https://github.com/oprypin/markdown-callouts):
    One of the great features of `mkdocs-material` in my opinion is [admonitions](https://squidfunk.github.io/mkdocs-material/reference/admonitions/), basically call-outs to include side-content or highlight content.
    However, it only looks nice when rendered, and is harder to read in plain Markdown or other renderers.
    `markdown-callouts` provides a less intrusive syntax.
    The advantage is that it has a [natural fallback for other renderers](https://github.com/oprypin/markdown-callouts#graceful-degradation), and it also has support for GitHub alerts[^2].

- sitemap override to include correct last modification date (using git plugin or blog metadata)

- robots.txt override

### Analytics and feedback widget

TBD

- integrated analytics via Umami (self-hosted)
- added feedback widget with analytics

### Comments

TBD

- unfortunately, no more comments since this gets you locked in to GitHub Discussions

### Archived posts

Some of the posts from my blog are quite old.
I started in 2011 and those posts don't reflect what I am doing these days.
I could have removed them, but I do believe in keeping them for historical reasons (and to avoid old links to cause 404 errors).

Instead, I "archived" old posts that I don't intend on keeping updated anymore.
At first, I used [snippets](https://squidfunk.github.io/mkdocs-material/setup/extensions/python-markdown-extensions/#snippets) to include into each archived page a dedicated Markdown snippet with the archive note.
Since adding tags, I moved this into a custom template that looks for the `archived` tag in a page's metadata.

### Bibliography

- bibliography of my publications

    - used a plugin (papercite) before but since data does not change much (or at all anymore) it is static now
    - manually added support for showing abstract and bibtex reference using some custom javascript and css to toggle visibility

### Project list

- project list

    - also manual in a grid view
    - unfortunately, no image carousel but used `glighbox` to be able to expand screenshots

### Deployment

#### Hosting static site

- deployment

    - deploy to a staging environment early on in the project
    - to get the full cycle going (automatic deployment from main)
    - looked for a simple static webserver and found `static-web-server` written in Rust with great features and secure defaults
    - at first, deployed by pulling repo on server and rebuilding image
    - later, when updating my stack, integrated as an image, CI pipeline pushes image and deploy job pulls image and re-creates container (separates production config from repo)

#### Ensuring old URLs still work/get redirect

- old sitemap and redirects

    - as part of going through all blog posts, also validated that links still work, lots of them didn't anymore, and needed to resort to archive.org version (fortunately did exist)
    - there is a Markdown plugin for this: htmlproofer which can ensure that external links still resolve
    - nowadays, a lot of sites are protected by Cloudflare which refuses requests from script with a 403 status code

- added rewrites from URLs of old website to new ones

    - static-web-server has a redirect feature
    - there was a small bug leading to infitinite loop redirect with path separators: https://github.com/orgs/static-web-server/discussions/498
    - was able to contribute (in Rust) and get it fixed: https://github.com/static-web-server/static-web-server/pulls?q=is%3Apr+is%3Aclosed+author%3Amschoettle+milestone%3Av2.34.0
    - set up a CI job that verifies that redirects won't change in the future
        - used the old sitemap from Wordpress and created a script that pulls out the URLs
        - CI job runs the project how it would be deployed and checks that each URL receives a redirect status code
        - did not include all possible URLs but that would have been good!
        - TODO: XML export includes absolute URLs, pull them out and add them
    - also good to check what Google shows in its search result for `site:domain.com` or `inurl:domain.com`
    - also go through site to find patterns of redirects

[^1]: This unfortunately only works in an easy way in the CI pipeline.
    This is because the semantic linebreak rule comes from an [additional `npm` package](https://www.npmjs.com/package/markdownlint-rule-max-one-sentence-per-line) that needs to be installed.
    Doing this does not consistently work across all places where `markdownlint` is invoked (pre-commit, editor, etc.).
    So this extra rule is [only used](https://github.com/mschoettle/website/blob/8b6708e32214a6604185635055e1462ca39f478a/.github/markdownlint/.markdownlint-cli2.yaml) in a [dedicated CI step](https://github.com/mschoettle/website/blob/8b6708e32214a6604185635055e1462ca39f478a/.github/workflows/ci.yml#L52).

[^2]: Unfortunately, the supported types between [GitHub Alerts](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts) and [admonitions](https://squidfunk.github.io/mkdocs-material/reference/admonitions/#supported-types) don't match.
    Due to that, there is currently a mix of styles in the Markdown files.
    At some point, I need change this to one consistent way of denoting admonitions.
