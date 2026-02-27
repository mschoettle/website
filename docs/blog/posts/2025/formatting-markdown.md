---
date:
  created: 2025-04-11
  updated: 2026-02-22
---

# Formatting Markdown files with `mdformat`

At some point I was looking at the [`.pre-commit-config.yaml` that the `ruff` project uses](https://github.com/astral-sh/ruff/blob/main/.pre-commit-config.yaml).
Looking at how other projects do things, what tools they use, how they work, etc. is a great way to learn.
I noticed several `pre-commit` hooks that were interesting, one of which was [`mdformat`](https://mdformat.readthedocs.io/en/stable/).

`mdformat` is "an opionionated Markdown formatter".
It has a specific [formatting style](https://mdformat.readthedocs.io/en/stable/users/style.html) that cannot be configured.
There are a few [configuration options](https://mdformat.readthedocs.io/en/stable/users/configuration_file.html) though.

The nice thing is that it has a [plugin system](https://mdformat.readthedocs.io/en/stable/users/plugins.html) giving you the ability to add support for syntax other than what is defined by [CommonMark](https://spec.commonmark.org/current/).
In addition, there is also support for code formatter plugins to format code in fenced code blocks.

For example, for a project that uses `mkdocs` with the fantastic [`mkdocs-material`](https://squidfunk.github.io/mkdocs-material/) theme (like this website uses), the [mdformat-mkdocs](https://github.com/hukkin/mdformat-mkdocs) plugin offers the necessary support.
You can find the see the setup that this website uses in the corresponding [`.pre-commit-config.yaml`](https://github.com/mschoettle/website/blob/57e589e57a029cfc41122bf20e8bb997f51aed2e/.pre-commit-config.yaml#L54-L68).

!!! note "Compatibility with `markdownlint`"

    [I have been using `markdownlint`](../2024/gitlab-ci-linting-markdown.md) for a while.
    Since both tools support _CommonMark_ they are basically compatible.

    I run both tools via `pre-commit` hooks.
    First, `mdformat`, and then `markdownlint-cli2` so that the linting is done on an already formatted file.

    The one thing that does not work, unfortunately, is when you use a comment to disable a certain `markdownlint` rule for the next line.
    `mdformat` adds an empty line in between the comment and the next line invalidating disabling the rule.

<!-- more -->

And now come my few seconds of fame :smile:

On [episode 425 of the Python Bytes podcast](https://pythonbytes.fm/episodes/show/425/if-you-were-a-klingon-programmer) the hosts were talking about formatting Python code in fenced code blocks in Markdown files.
One of the hosts mentioned that it would be great to have a formatter for Markdown files as well.

Since I had just come across `mdformat` I sent it in and it was covered in the [next episode](https://pythonbytes.fm/episodes/show/426/committing-to-formatted-markdown).
The episode was even titled "Committing to Formatted Markdown".

> I mentioned it'd be nice to have an autoformatter for Markdown files...<br>
> Matthias delivered with suggesting `mdformat`.
>
> — Brian on [Python Bytes #426](https://pythonbytes.fm/episodes/show/426/committing-to-formatted-markdown)
