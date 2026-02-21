---
date:
  created: 2024-10-15
  updated: 2026-02-20
categories:
  - CI/CD or Automation?
---
# Linting Markdown files in GitLab CI

A while ago I was looking for a way to lint Markdown files and came across [`markdownlint`]() in my search.
There are two CLI tools for it, [`markdownlint-cli`]() and [`markdownlint-cli2`]().
Based on the comparison I started using `markdownlint-cli2`.

It has lots of supported ways of invocation, such as a [pre-commit hook](), [VSCode extension](), and a [container image]() containing custom rules.

We are using GitLab which supports the ability to [annotate merge request diffs with code quality findings]() following the [Code Climate specification]().

There was unfortunately no support for this yet.
At first, I wrote a custom formatter that lived in our repo.
But I wanted to make it available to all our repositories, and the all `markdownlint-cli2` users.
As a result, I ended up contributing a [code climate formatter]() to `markdownlint-cli2`.

One thing that is a bit tricky is to have a consistent developer experience.
`markdownlint-cli2` is invoked locally in the IDE via the extension, at commit-time as a pre-commit hook, and in CI.
Locally, we want to use the pretty formatter, whereas in CI we want to use a different one (in our case, the code climate one).

The way this can work is by having a dedicated config for
