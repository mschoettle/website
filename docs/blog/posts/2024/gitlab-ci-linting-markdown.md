---
categories:
  - CI/CD
date:
  created: 2024-10-15
  updated: 2026-02-20
tags:
  - automation
  - gitlab ci
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
At first, I [wrote a custom formatter](https://github.com/DavidAnson/markdownlint-cli2#output-formatters) that lived in our private repo.
But I instead of leaving it buried in a private repo, I wanted to make it available to all our repositories and all `markdownlint-cli2` users.
I checked if there was appetite for [integrating this into `markdownlint-cli2`](https://github.com/DavidAnson/markdownlint-cli2/issues/92) and ended up [contributing a code quality formatter](https://github.com/DavidAnson/markdownlint-cli2/pull/93).
It is published as an npm package: https://www.npmjs.com/package/markdownlint-cli2-formatter-codequality.

<!-- more -->

!!! tip "Mentioned in the GitLab documentation"

    As I am getting the latest URLs to the GitLab documentation I noticed that [this formatter is now also mentioned in it](https://docs.gitlab.com/ci/testing/code_quality/#markdownlint-cli2) :smile:

One thing that is a bit tricky is to have a consistent developer experience.
`markdownlint-cli2` is invoked locally in the IDE via the extension, at commit-time as a pre-commit hook, and in CI.
In our case, we run this in non-JavaScript-based projects meaning that we can't just add the formatter as a development dependency.
In addition, locally, we want to use the pretty formatter, whereas in CI we want to use the code quality formatter (or both for job logs).

The way this can work is by having a dedicated config for CI.
This can be used on its own just to define the additional formatter, or extend the `markdownlint-cli2` root config.

In the latter case, this is how it would look:

```console
my_awesome_project
 ├─ .gitlab
 │  └─ .markdownlint-cli2.yaml
 └─ .markdownlint-cli2.yaml
```

```yaml title=".markdownlint-cli2.yaml"
# https://github.com/DavidAnson/markdownlint-cli2#markdownlint-cli2yaml

ignores:
  - .gitlab/merge_request_templates/Default.md

gitignore: true
```

```yaml title=".gitlab/.markdownlint-cli2.yaml"
# https://github.com/DavidAnson/markdownlint-cli2#markdownlint-cli2yaml

# additional configuration to the config in the root of the project
# this additional config is used during the markdownlint CI job

outputFormatters:
  -   - markdownlint-cli2-formatter-default
  -   - markdownlint-cli2-formatter-codequality
```

Now, you can run `markdownlint-cli2` in GitLab CI/CD in a job as follows:

```yaml
markdownlint:
  stage: lint
  image:
    name: davidanson/markdownlint-cli2:<version> # (1)
    # overwrite default entrypoint (which is a call to markdownlint-cli2)
    entrypoint: ['']
  script:
    # use the config file that is stored outside the root
    - markdownlint-cli2 --config .gitlab/.markdownlint-cli2.yaml "**/*.md"
  artifacts:
    when: always
    reports:
      codequality: markdownlint-cli2-codequality.json
```

1. Avoid surprises and pin the version.
    Then use [Renovate](https://docs.renovatebot.com) to get automated dependency updates.

One tricky thing in terms of consistent developer experience is using custom rules.
There are some [helpful rules provided in the `davidanson/markdownlint-cli2-rules` image](https://github.com/DavidAnson/markdownlint-cli2/blob/main/docker/Dockerfile-rules).
While it is easy to switch to that image in the CI job, it is tricky to get the same experience locally (again, if you are dealing with a non-JavaScript project).
The [vscode extension does not support custom rules](https://github.com/DavidAnson/vscode-markdownlint/issues/336).

Due to that, I ended up specifying the custom rule in the GitLab-specific configuration file.
It's a bit annoying to have your pre-commit checks pass locally only to find out that the linting job in the pipeline fails.

!!! question "What if I am using GitHub Actions?"

    You can apply the same concept as shown in this post.
    See this [reusable `markdownlint` workflow](https://github.com/opalmedapps/.github/blob/main/.github/workflows/markdownlint.yaml) that creates the dedicated config file on the fly.
    You might want to use the [`markdownlint-cli2-action`](https://github.com/marketplace/actions/markdownlint-cli2-action) in your CI job which contains a formatter that contains annotations.
