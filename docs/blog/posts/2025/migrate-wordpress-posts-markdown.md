---
categories:
  - Projects
date:
  created: 2025-12-09
  updated: 2025-12-28
links:
  - blog/posts/2024/blog-relaunched.md
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
3. Select that you want to export "All content"
4. Click "Download Export File"

Looking at the resulting XML file, I quickly saw that this can be automated to extract the posts and output them in the structure needed in Markdown.
The XML file contains a lot of information, pretty much everything that is needed.

I ~~carefully crafted~~ hacked together a script and iterated a while to get as much as possible converted.
At first, I focussed on blog posts, and treated project posts separately after.

The script extracts the relevant information about each post into a `NamedTuple`.
The post content is cleaned up as much as possible automatically.
For each post a Markdown file is created using a [Jinja2](https://jinja.palletsprojects.com/en/stable/) template with the basic structure.
I have discovered [`mdformat`](https://mdformat.readthedocs.io/en/stable/) since writing this script, so I added formatting using `mdformat` to the script.

!!! tip "Migration script"

    Put the below script at the root of your project and add the XML backup as `export.xml`.

    Run the script using [`uv`](https://docs.astral.sh/uv/):

    ```shell
    uv run migrate_blogposts.py
    ```

    The migrated blog posts will be in `docs/posts_migrated/` organized by year.
    If you have a lot of posts per year, you might want to structure it further by month.

    The type of post is in the `wp:post_type` element in the exported XML.
    By default, the script migrates the post type `post` (blog posts).
    If you have other kinds of posts that you want to migrate you can adjust the `MIGRATE_POST_TYPE` constant.

    ??? example "migrate_blogposts.py"

        ````python
        # /// script
        # requires-python = ">=3.12"
        # dependencies = [
        #     "jinja2",
        #     "markdownify",
        #     "mdformat",
        #     "mdformat-front-matters",
        #     "mdformat-mkdocs",
        # ]
        # ///
        import datetime as dt
        import html
        import json
        import xml.etree.ElementTree as ET
        import zoneinfo
        from pathlib import Path
        from typing import NamedTuple

        import mdformat
        from jinja2 import Environment, BaseLoader, StrictUndefined, select_autoescape
        from markdownify import markdownify

        EXPORT_FILE = "export.xml"
        # the wp:post_type of posts to migrate
        MIGRATE_POST_TYPE = "post"
        # write blogposts.json for debugging purposes
        WRITE_JSON = True
        TZ_SOURCE = zoneinfo.ZoneInfo("Europe/Berlin")
        TZ_TARGET = zoneinfo.ZoneInfo("America/Toronto")


        class Post(NamedTuple):
            title: str
            link: str
            # published: dt.datetime
            posted: dt.datetime | None
            modified: dt.datetime | None
            content: str
            post_name: str
            status: str
            categories: list[str]
            meta: list[dict[str, str]]
            comments: list


        def serialize_JSON(obj):
            if isinstance(obj, (dt.datetime, dt.date)):
                return obj.isoformat()

            raise TypeError("Type %s not serializable" % type(obj))


        def convert_html(content: str) -> str:
            result = []
            markdownify_tags = ["<a", "<p>", "<h3>", "<!-- wp", "<!-- /wp", "<img"]

            for line in content.splitlines():
                # only convert lines if they contain a detected tag, otherwise too much might get swallowed
                # such as <!-- more -->
                if any(tag in line for tag in markdownify_tags):
                    line = markdownify(
                        line,
                        heading_style="ATX",
                        escape_underscores=False,
                        escape_asterisks=False,
                        escape_misc=False,
                    )

                result.append(line)

            return "\n".join(result)


        def convert_content(content: str):
            if content:
                # return content
                content = content.replace(
                    "<!--more-->",
                    "<!-- more -->",
                )
                content = content.replace(
                    "<blockquote><code>",
                    "\n```\n",
                )
                content = content.replace(
                    "\n</code></blockquote>",
                    "\n```\n",
                )
                content = content.replace(
                    "</code></blockquote>",
                    "\n```\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="xml" class="language-xml">',
                    "\n```xml\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="java" class="language-java">',
                    "\n```java\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="css" class="language-css">',
                    "\n```css\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="python" class="language-python">',
                    "\n```python\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="markup" class="language-markup">',
                    "\n```html\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="javascript" class="language-javascript">',
                    "\n```css\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="" class="">', "\n```\n"
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="bash" class="language-bash">',
                    "\n```shell\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="sql" class="language-sql">',
                    "\n```sql\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="yaml" class="language-yaml">',
                    "\n```yaml\n",
                )
                content = content.replace(
                    '<pre class="wp-block-code"><code lang="php" class="language-php">',
                    "\n```php\n",
                )
                content = content.replace("</code></pre>", "\n```\n")
                content = content.replace("<pre>", "\n```\n")
                content = content.replace("</pre>", "```\n")
                content = content.replace("<code>", "`")
                content = content.replace("</code>", "`")

                content = content.replace("<em>", "_")
                content = content.replace("</em>", "_")
                content = content.replace("<blockquote>", "\n```\n")
                content = content.replace("</blockquote>", "\n```\n")
                content = content.replace("<strong>", "**")
                content = content.replace("</strong>", "**")
                content = content.replace("<ul>\n", "")
                content = content.replace("</ul>\n", "")
                content = content.replace("<li>\n", "* ")
                content = content.replace("</li>\n", "")
                content = convert_html(content)
                # has to come after convert HTML, otherwise it will be completely removed
                content = content.replace("&lt;", "<")
                content = content.replace("&gt;", ">")
                content = content.replace("&amp;", "&")

            return content


        tree = ET.parse(EXPORT_FILE)
        root = tree.getroot()
        channel = root[0]

        items = channel.findall("item")
        posts = []

        for item in items:
            post_type = item.find("{http://wordpress.org/export/1.2/}post_type").text
            # can check for other types of posts that are of interest as well
            if post_type == MIGRATE_POST_TYPE:
                title = item.find("title").text
                link = item.find("link").text
                published = item.find("pubDate").text
                posted = item.find("{http://wordpress.org/export/1.2/}post_date_gmt").text
                modified = item.find("{http://wordpress.org/export/1.2/}post_modified_gmt").text
                content = item.find("{http://purl.org/rss/1.0/modules/content/}encoded").text
                post_name = item.find("{http://wordpress.org/export/1.2/}post_name").text
                status = item.find("{http://wordpress.org/export/1.2/}status").text
                categories = [category.text for category in item.findall("category")]
                post_meta = [
                    {"key": meta[0].text, "value": meta[1].text}
                    for meta in item.findall("{http://wordpress.org/export/1.2/}postmeta")
                ]
                comments = [
                    ET.tostring(comment).decode()
                    for comment in item.findall("{http://wordpress.org/export/1.2/}comment")
                ]

                print(title)

                posts.append(
                    Post(
                        title=title,
                        link=link,
                        posted=dt.datetime.fromisoformat(posted)
                        .replace(tzinfo=TZ_SOURCE)
                        .astimezone(TZ_TARGET)
                        if published
                        else dt.datetime.now(tz=TZ_TARGET),
                        modified=dt.datetime.fromisoformat(modified)
                        .replace(tzinfo=TZ_SOURCE)
                        .astimezone(TZ_TARGET)
                        if published
                        else dt.datetime.now(tz=TZ_TARGET),
                        content=convert_content(content),
                        post_name=post_name,
                        status=status,
                        categories=categories,
                        meta=post_meta,
                        comments=comments,
                    )
                )

        posts = sorted(
            posts, key=lambda x: x.posted if x.posted else dt.datetime.now(tz=dt.UTC)
        )

        # export to JSON for debugging purposes
        if WRITE_JSON:
            with Path("blogposts.json").open("w") as fd:
                json.dump(
                    [post._asdict() for post in posts], fd, indent=4, default=serialize_JSON
                )

        env = Environment(
            loader=BaseLoader(),
            autoescape=select_autoescape(),
            # raise exception if undefined variable is used in template
            undefined=StrictUndefined,
        )

        POST_TEMPLATE = """---
        migrated: true
        date:
        created: {{ post.posted.date() }}
        updated: {{ post.modified.date() }}
        {%- if post.status == 'draft' %}
        draft: true
        {%- endif %}
        {%- if post.categories %}
        categories:
        {%- for category in post.categories %}
        - {{ category }}
        {%- endfor %}
        {%- endif %}
        slug: {{ post.post_name }}
        ---
        # {{ post.title }}

        {{ post.content }}
        """

        template = env.from_string(POST_TEMPLATE)

        for post in posts:
            parent = Path("docs/posts_migrated")
            parent.mkdir(exist_ok=True)

            if post.posted:
                parent = parent.joinpath(str(post.posted.year))

            parent.mkdir(exist_ok=True)

            filename = post.post_name if post.post_name else "undefined"

            with parent.joinpath(f"{filename}.md").open("w") as fp:
                rendered = template.render(post=post)
                # unescape HTML entities
                unescaped = html.unescape(rendered)
                formatted = mdformat.text(
                    unescaped,
                    extensions={"front_matters", "mkdocs"},
                )
                fp.write(formatted)
        ````

    You might notice that there are still some HTML tags that are not converted.
    I chose to be more conservative and not `markdownify` every line of the post content.
    This is to avoid losing certain information, such as the `<!-- more -->` indicator.
    The [`markdownify` package has a bunch of options](https://github.com/matthewwithanm/python-markdownify?tab=readme-ov-file#options) and it would have probably been possible to write a [custom converter](https://github.com/matthewwithanm/python-markdownify?tab=readme-ov-file#creating-custom-converters) instead to handle some special cases.

Writing the script was the easy part.
What came after was going through each blog post and cleaning it up, making sure it renders correctly.
This also gave me the opportunity to fix some formatting, typos, and grammar issues.
And, I made sure to make use of the many [features of `mkdocs-material`](https://squidfunk.github.io/mkdocs-material/reference/) to further improve how everything is presented.

[^1]: I used the [Portfolio and Projects plugin](https://wordpress.org/plugins/portfolio-and-projects/) to showcase some of my work.
    The plugin uses a custom post type for projects that are then arranged on a dedicated page.
