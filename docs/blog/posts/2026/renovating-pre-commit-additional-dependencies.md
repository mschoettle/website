---
date:
  created: 2026-02-22
  updated: 2026-02-24
tags:
  - automation
  - code quality
  - how to
  - open source
---

# Updating pre-commit additional dependencies using Renovate

I am a huge fan of [Renovate Bot](https://docs.renovatebot.com) to automatically update dependencies in projects.
I use it in all my projects.
At the time when I discovered it, we were using GitLab so we could not use _dependabot_.

In general, I quickly realized that _Renovate Bot_ has significant advantages over _dependabot_ (which, if I am not mistaken, is restricted to running on GitHub).
Renovate is fully [open source](https://github.com/renovatebot/renovate/) (and can be [self-hosted](https://docs.renovatebot.com/examples/self-hosting/)), [highly configurable](https://docs.renovatebot.com/configuration-options/), supports many [dependency managers](https://docs.renovatebot.com/modules/manager/), supports [custom managers with regex](https://docs.renovatebot.com/modules/manager/regex/), and much more.

Renovate has been having [beta pre-commit support](https://docs.renovatebot.com/modules/manager/pre-commit/#enabling) for quite some time which needs to be enabled explicitly.
I have been using it for a while and it works great in keeping up-to-date with updates to `pre-commit` hooks (it is generally recommended to [pin dependencies](https://docs.renovatebot.com/dependency-pinning/)).

`pre-commit` hooks can have additional dependencies.
These additional dependencies are specific to the language the hook uses.
For example, let's assume you are using [`mdformat` to format your Markdown files](../2025/formatting-markdown.md) which supports additional plugins.
`mdformat` is a Python tool so the additional dependencies are Python packages.

Here is an example `pre-commit` config that this website uses as of this writing:

```yaml title=".pre-commit-config.yaml (excerpt)"
- repo: https://github.com/executablebooks/mdformat
rev: 1.0.0
hooks:
    - id: mdformat
    language: python
    args: [--number, --sort-front-matter, --strict-front-matter]
    additional_dependencies:
        - mdformat-mkdocs==5.1.4
        - mdformat-front-matters==2.0.0
        - mdformat-footnote==0.1.3
        - mdformat-gfm-alerts==2.0.0
        - mdformat-ruff==0.1.3
        - ruff==0.15.4
        - mdformat-config==0.2.1
```

1. Specifying the language is optional but important here as you will see when you keep reading.

How can we ensure that the additional dependencies receive get updated automatically as well?

<!-- more -->

There has been a long-standing [issue to add support for `additional_dependencies`](https://github.com/renovatebot/renovate/issues/20780).
The main challenge is basically to know which dependency manager
At some point, someone contributed support for updating additional dependencies for Python.
The trick is to [add the language property to the hook](https://docs.renovatebot.com/modules/manager/pre-commit/#additional-dependencies).
This is already defined in the definition of the hook itself.
However, specifying it here helps Renovate in determining what dependency manager to use for package lookups.

At some point, support was also added to `node` additional dependencies.

Which now brings me to [my latest contribution to Renovate](https://github.com/renovatebot/renovate/pulls?q=sort%3Aupdated-desc+is%3Apr+author%3Amschoettle+is%3Aclosed).
I use [`actionlint`](https://github.com/rhysd/actionlint) to statically check GitHub Action workflows in many projects.
The amazing thing is that `actionlint` has an [integration for `shellcheck` for `run:` scripts](https://github.com/rhysd/actionlint/blob/main/docs/checks.md#check-shellcheck-integ).

Via the [`pre-commit` config of the `ruff` project](https://github.com/astral-sh/ruff/blob/af3c21bb9251a3b04f92624d63dd84243e73202d/.pre-commit-config.yaml#L152-L156) I initially came across `actionlint` and also saw how `shellcheck` can be used.
Basically, there is a Go package for shellcheck.

```yaml title=".pre-commit-config.yaml (excerpt)"
- repo: https://github.com/rhysd/actionlint
rev: v1.7.11
hooks:
    - id: actionlint
    language: golang
    additional_dependencies:
    # see also: https://github.com/rhysd/actionlint/pull/482
        - github.com/wasilibs/go-shellcheck/cmd/shellcheck@v0.11.1
```

The problem I had is that when `go-shellcheck` got updated I missed it.
And Renovate had no support for Go additional dependencies at the time.
I only noticed that there was a new version when pipelines started failing sporadically due to a memory violation coming from the shellcheck invocation.

To get updates in the future, I looked at how support for `node` was added and replicated the same concept for Go.
I [opened a PR](https://github.com/renovatebot/renovate/pull/39469) that got accepted and support has been available since [version 42.76.0](https://github.com/renovatebot/renovate/releases/tag/42.76.0).
It then took a few days for this version to be used by the GitHub app.

Thanks to some backlinks in the PR I saw that `ruff` and `ty` updated the `go-shellcheck` version manually in their `pre-commit` config.
I noticed that the `language` property was missing in their `pre-commit` config so I raised PRs ([ruff PR](https://github.com/astral-sh/ruff/pull/22483), [ty PR](https://github.com/astral-sh/ty/pull/2423)) so they get automatic updates for this additional dependency by Renovate in the future :).
