---
categories:
  - CI/CD
date:
  created: 2024-10-15
  updated: 2026-02-20
tags:
  - automation
  - ci/cd
  - gitlab ci/cd
---

# Linting Markdown files in GitLab CI

A while ago I was looking for a way to lint Markdown files and came across [`markdownlint`](https://github.com/DavidAnson/markdownlint) in my search.
There are two CLI tools for it, [`markdownlint-cli`](https://github.com/igorshubovych/markdownlint-cli) and [`markdownlint-cli2`](https://github.com/DavidAnson/markdownlint-cli2).
Based on the [comparison and rationale by one of the authors](https://dlaa.me/blog/post/markdownlintcli2) I gave `markdownlint-cli2` a try first.

It is node-based and has lots of supported ways of invocation, such as a [pre-commit hook](https://github.com/DavidAnson/markdownlint-cli2#pre-commit), works well with the [markdownlint vscode extension](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint), and [can be run as a container](https://github.com/DavidAnson/markdownlint-cli2#container-image) (including an image containing custom rules).

We are using GitLab which has [code quality scanning support](https://docs.gitlab.com/ci/testing/code_quality/).
You can [import code quality results from a CI/CD job](https://docs.gitlab.com/ci/testing/code_quality/#import-code-quality-results-from-a-cicd-job).
[Depending on the tier](https://docs.gitlab.com/ci/testing/code_quality/#features-per-tier) you have, you can [see code quality findings in various places in the merge request UI](https://docs.gitlab.com/ci/testing/code_quality/#view-code-quality-results) helping the merge request author and reviewer(s).
The code quality findings are provided as a JSON file during a CI/CD job.
The [report format is based on the CodeClimate report specification](https://docs.gitlab.com/ci/testing/code_quality/#code-quality-report-format).

There was unfortunately no support for this yet.
At first, I wrote a custom formatter that lived in our repo.
But I wanted to make it available to all our repositories, and the all `markdownlint-cli2` users.
As a result, I ended up contributing a [code climate formatter](https://github.com/DavidAnson/markdownlint-cli2/issues/92) to `markdownlint-cli2`.

One thing that is a bit tricky is to have a consistent developer experience.
`markdownlint-cli2` is invoked locally in the IDE via the extension, at commit-time as a pre-commit hook, and in CI.
Locally, we want to use the pretty formatter, whereas in CI we want to use a different one (in our case, the code climate one).

The way this can work is by having a dedicated config for
