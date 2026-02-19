---
categories:
  - Projects
date:
  created: 2024-12-17
  updated: 2026-02-18
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

#### Sitemap override

`mkdocs` generates a `sitemap.xml` by default.
However, the `<lastmod>` element always contains the date when the site was built which is obviously incorrect.
I added a [custom sitemap template](https://github.com/mschoettle/website/blob/47add7eea5c29228d54e5e9bb34240ce9d24e69f/overrides/sitemap.xml) that is [based on this how to](https://timvink.github.io/mkdocs-git-revision-date-localized-plugin/howto/override-a-theme/#example-populate-sitemapxml).
Basically, for regular pages, the last modification date is retrieved from git via the `git-revision-date-localized` plugin.
For pages that were generated by a template (such as blog posts), the last modification date is retrieved from the metadata of the page defined in the frontmatter.
Either from `date: updated:`, or if that doesn't exist, `date: created:`

#### `robots.txt` override

When looking at access logs I noticed that there are a lot of `404` reported.
Most of these are coming from a missing `robots.txt`.
So I added a [simple one](https://github.com/mschoettle/website/blob/47add7eea5c29228d54e5e9bb34240ce9d24e69f/overrides/robots.txt) to start with that allows all user agents and points to the sitemap URL.

#### Comments

With Wordpress it was easy to allow visitors to comment on posts.
Some of my posts received comments (in particular the [Firefox close button on hover](../2016/firefox-close-tab-button-on-hover.md) one) and it was great to get some interaction.
Knowing that a post helped someone is rewarding and motivating.
It also helped to update and improve blog posts using the feedback from commenters.

Given that it is now a static site having comments is not that simple.
`mkdocs-material` supports [integration with _Giscus_](https://squidfunk.github.io/mkdocs-material/setup/adding-a-comment-system/).
Giscus is an app for GitHub that makes use of GitHub Discussions.
The integration looks great and it was tempting to integrate it, however, I did not like that the comment data are stored elsewhere.
You are basically locked into GitHub Discussions.
In addition, it requires users to have an account on another platform.

So for now, I decided not to have comments.

#### Analytics and feedback widget

It could be helpful to know which posts visitors look at most often and where they are coming from.
Recently, I [integrated analytics and a feedback widget](https://github.com/mschoettle/website/pull/163).
I self-hosted [umami](https://umami.is/) which is an open-source analytics platform that preserves visitor privacy[^3].

`mkdocs-material` makes it easy to integrate [custom site analytics](https://squidfunk.github.io/mkdocs-material/setup/setting-up-site-analytics/#custom-site-analytics).

It is also easy to add a [custom feedback widget](https://squidfunk.github.io/mkdocs-material/setup/setting-up-site-analytics/#custom-site-feedback) at the end of each post to allow users to report whether the post helped them (or not).

`umami` supports events.
So when a user uses the feedback widget, an event with the URL of the current page is recorded via the [Umami Events API](https://umami.is/docs/tracker-functions#events).

### Content

#### Archived posts

Some of the posts from my blog are quite old.
I started in 2011 and those posts don't reflect what I am doing these days.
I could have removed them, but I do believe in keeping them for historical reasons (and to avoid dead links).

Instead, I "archived" old posts that I don't intend on keeping updated anymore.
At first, I used [snippets](https://squidfunk.github.io/mkdocs-material/setup/extensions/python-markdown-extensions/#snippets) to include into each archived page a dedicated Markdown snippet with the archive note.
Since adding tags, I moved this into a custom template that looks for the `archived` tag in a page's metadata.

#### Bibliography

I show all my [publications](../../../research/index.md) and provide the PDF version on my website.
With Wordpress I used a plugin called _papercite_ that can load a _BibTeX_ (bibliography) file and show the papers.
It also had a nice way of expanding the abstract and _BibTeX_ entry if someone cites this paper.

The list of papers is fairly static so I converted this whole list to Markdown and added hidden sections for the abstract and citation.
Basically, the hidden sections use admonitions.
With a little bit of [custom JavaScript](https://github.com/mschoettle/website/blob/5a894f950e555413427b36fb27755b0a24eea8bc/docs/assets/javascript/extra.js) and [CSS](https://github.com/mschoettle/website/blob/5a894f950e555413427b36fb27755b0a24eea8bc/docs/assets/stylesheets/extra.css#L23-L26) it is possible to toggle the visibility of those.

#### Project list

I show a [list of professional and personal projects](../../../projects/index.md).
With WordPress I used the [Portfolio and Projects plugin](https://wordpress.org/plugins/portfolio-and-projects/).

Now, I manually arranged them in Markdown using a [grid](https://squidfunk.github.io/mkdocs-material/reference/grids/).
Unfortunately, there is no image carousel in `mkdocs-material` so I only kept the most important screenshots.
Using the [glightbox plugin](https://squidfunk.github.io/mkdocs-material/reference/images/#lightbox) it is at least possible to zoom into images.

### Deployment

It's good to get a production-like deployment set up very early on in the project.
This is to ensure that the whole cycle works and that there won't be any surprises at the very end before going live.
Basically, what I wanted is to automatically deploy every time a new commit is pushed to/merged into `main`.

I usually use [`traefik`](https://doc.traefik.io/traefik/) as my reverse proxy to handle TLS termination, certificates with _Let's Encrypt_, and routing to the different containers of the stack.

To host the static site I needed a webserver that can serve the static files.

With the _WordPress_ site I was using a web hoster at first.
Usually, web hosters provide _nginx_ or _Apache 2_ as a webserver with support for PHP etc.
Then later, as mentioned in the introduction of this article, I switched to my own server where it was running as a container.
Both of these were served via _Apache 2_.
I did use _Apache 2_ a lot at the beginning of my journey and know the config quite well.

I use _nginx_ here and there and it was definitely a good option.
For a lot of people it is the go-to webserver.
Another interesting option is _Caddy_ which I've been meaning to try out for a while.

I did want to look around and see if there is any other option out there for a static web server.

This search lead me to [Static Web Server](https://static-web-server.net/), an open source web server written in Rust to serve static files.
In the Python ecosystem there have been a number of projects in the last few years (such as `pydantic`, `ruff`, and `uv`) that use Rust underneath to improve the performance.
So this did look interesting.
The [list of features](https://static-web-server.net/#features) pretty much covered what I was looking for:

- suitable for running as a container
- configurable via environment variables or a TOML file
- security headers by default
- URL rewrites/redirects

So I gave it a quick try and liked how easy it was to run and configure.

At first, I did a very simple deployment that consisted of pulling the repository on the server, rebuilding the image, and re-creating the container.
This required the production compose file to be part of my website repository.
Later, when updating my stack, I integrated it directly into the stack by using a container image.
The CI pipeline builds and pushes the image, the deploy job then triggers the image to be pulled and the container re-created.
That way, the production configuration is separated from the website repository.

### Ensuring old URLs are still reachable

One of the things I learned a long time ago in my web development journey is that it is important to ensure that old URLs are still reachable.
For instance, if a search engine has indexed your site, and determines that the indexed URLs are not reachable anymore, it will remove URLs from its index.

On the other hand, it can be quite annoying when one finds a link somewhere only to realize that the site does not exist anymore, or the link leads to a `404`.
Fortunately, we have the [Internet Archive](https://archive.org) that often has archived a page.

#### Outgoing links in content

As part of going through all blog posts I also validated that outgoing links still work.
Unfortunately, there were quite a few that did not work anymore.
Fortunately, most if not all were archived by the _Internet Archive_ and it was possible to replace the link with the archived version.

There is also an [MkDocs plugin called `htmlproofer`](https://github.com/manuzhang/mkdocs-htmlproofer-plugin) that can validate all links automatically during build.
It is a quite slow process so I would recommend to only enable this in CI.
Fortunately or unfortunately, a lot of sites are nowadays protected by _CloudFlare_ which refuses requests from scripts by returning a `403` status code.
Or rather, I believe they return an intermediate page first that requires the user to click a button or confirm that they are human.
So these URLs need to be excluded.

Since I went through all URLs recently I did not use this plugin.
Of course, it can always happen that all of a sudden, one of the URLs that still worked is now a dead link.

#### Redirecting URLs from old website to new website

And that also applies to my own website.
It's important to make sure that there are no dead links for my own website.
If permanent redirects (HTTP status code `301`) are returned, the search indexes will be updated eventually to point to the new URLs.

`static-web-server` has a nice [URL redirects feature](https://static-web-server.net/features/url-redirects/) that allows you to define using [glob matching syntax](<https://en.wikipedia.org/wiki/Glob_(programming)>).
This is one of the reasons I wanted to try `static-web-server`.
It is much easier to write redirects this way than using regular expressions.

!!! tip "Contribution to `static-web-server`"

    There was a small bug I experienced with the URL redirects feature leading to an [infinite redirect loop with path separators](https://github.com/orgs/static-web-server/discussions/498).
    The wildcard `*` was also matching the path separator, so a [combination of redirect rules](https://github.com/orgs/static-web-server/discussions/498#discussioncomment-11293253) caused an infinite redirect loop.

    It turned out that the [`globset` crate](https://docs.rs/globset/0.4.15/globset/#syntax) that `static-web-server` is using has a way to configure it to prevent the path separator from being matched.
    Enabling `literal_separator` prevents the path separator from being matched by `*`.

    I was able to make [my first contribution in Rust](https://github.com/static-web-server/static-web-server/pulls?q=is%3Apr+is%3Aclosed+author%3Amschoettle+milestone%3Av2.34.0) this way and get this fixed :tada:.

    Starting with [v2.34.0](https://github.com/static-web-server/static-web-server/blob/master/CHANGELOG.md#v2340---2024-12-04) the path separator does not get matched anymore by wildcards.

The first step is to find old URLs.
I used the sitemap generated by Wordpress, used the WordPress backup, looked at what Google returns using `site:mattsch.com` or `inurl:mattsch.com`, and also looked through the website manually to find patterns URLs.

I collected all these URLs in a list so that I can automatically check that they redirect.

##### WordPress sitemaps

WordPress uses several sitemaps that are referenced in `sitemap.xml`.
I downloaded them all and wrote a small script to parse them.

```python
from xml.etree import ElementTree as ET


tree = ET.parse("sitemaps/sitemap.xml")
root = tree.getroot()

urls = []

for child in root:
    url = child.find("{http://www.sitemaps.org/schemas/sitemap/0.9}loc").text
    urls.append(url)

    for image in child.findall(
        "{http://www.google.com/schemas/sitemap-image/1.1}image"
    ):
        image_url = image[0].text
        urls.append(image_url)
```

That gives you a rough list which likely misses some URLs.
I also looked in the WordPress backup to find URLs.

```python
import re
import xml.etree.ElementTree as ET
from pathlib import Path

BACKUP_FILE = "/path/to/wordpress.backup.xml"
URL_PREFIX = "https://mattsch.com"
URL_RE = re.compile(r"(https://mattsch\.com[^\s]+)")


def extract_urls(text: str) -> list[str]:
    urls = URL_RE.findall(text)

    return urls


tree = ET.parse(BACKUP_FILE)
root = tree.getroot()

urls: set[str] = set()

for element in root.iter():
    if element.attrib.get("isPermaLink") == "false":
        continue

    if element.text and URL_PREFIX in element.text:
        extracted_urls = extract_urls(element.text)

        urls.update(extracted_urls)

print(f"Found {len(urls)} old URLs.")
```

I combined all these findings to combile one `urls.json`.

##### Automatically checking redirects

With the above list of old URLs I wrote another script and CI job that checks that these redirect.

```python title="check_redirects.py"
import json
import sys
from http import HTTPStatus
from pathlib import Path

import requests


def check_redirect(url: str) -> bool:
    url = f"http://localhost{url}"
    print(f"checking URL: {url}")
    response = requests.get(url)

    if response.status_code != HTTPStatus.OK:
        print(f"ERROR: URL {url} returned: {response.status_code}")
        return False

    return True


with Path(".github/redirects/urls.json").open() as fd:
    urls = json.load(fd)

result = True

for url in urls:
    result &= check_redirect(url)

if not result:
    sys.exit(1)
```

I then run the stack how it would be in production via `docker compose` in a CI job and check all redirects (hence the local host).

```yaml "check redirects workflow steps (excerpt)"
steps:
  # after checkout
  - name: Run the stack
    run: docker compose up --build -d
  - name: Check redirects
    run: uv run --script .github/redirects/check_redirects.py
  - name: Stop stack
    run: docker compose down
```

This way we can make sure that redirects won't change in the future.

[^1]: This unfortunately only works in an easy way in the CI pipeline.
    This is because the semantic linebreak rule comes from an [additional `npm` package](https://www.npmjs.com/package/markdownlint-rule-max-one-sentence-per-line) that needs to be installed.
    Doing this does not consistently work across all places where `markdownlint` is invoked (pre-commit, editor, etc.).
    So this extra rule is [only used](https://github.com/mschoettle/website/blob/8b6708e32214a6604185635055e1462ca39f478a/.github/markdownlint/.markdownlint-cli2.yaml) in a [dedicated CI step](https://github.com/mschoettle/website/blob/8b6708e32214a6604185635055e1462ca39f478a/.github/workflows/ci.yml#L52).

[^2]: Unfortunately, the supported types between [GitHub Alerts](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts) and [admonitions](https://squidfunk.github.io/mkdocs-material/reference/admonitions/#supported-types) don't match.
    Due to that, there is currently a mix of styles in the Markdown files.
    At some point, I need change this to one consistent way of denoting admonitions.

[^3]: One small caveat is that it is quite likely that users of my website are using adblockers.
    Since this is about analytics it is possible that the required tracker script gets filtered out.
    I followed the how to on [bypassing ad blockers](https://umami.is/docs/bypass-ad-blockers) in the Umami documentation which helps with that.
    In addition, I made sure that the reverse proxy is collecting access logs so that those can also be analyzed if needed.
