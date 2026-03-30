---
categories:
  - CI/CD
date:
  created: 2026-03-28
tags:
  - automation
  - code quality
  - github actions
  - security
---

# Harden your GitHub Actions Workflows with `zizmor`, dependency pinning, and dependency cooldowns

It's been a crazy week (or weeks?) for a lot of people with [several supply chain attacks](https://ramimac.me/teampcp/).
They all seem to have originated from the [compromise of `trivy`](https://www.stepsecurity.io/blog/trivy-compromised-a-second-time---malicious-v0-69-4-release) (ironically, `trivy` is a security scanner).
I wanted to understand how they initially gained access to the secrets and found that there was an [earlier attack that targeted GitHub Actions pipelines of open source projects](https://www.stepsecurity.io/blog/hackerbot-claw-github-actions-exploitation).

Looking at the details of how the secrets were extracted I noticed that they all used similar techniques.
And, unless I missed something, it is through template injection and unsafe `pull_request_target` triggers.
All of those vulnerabilities (and more) can be found by [`zizmor`](https://zizmor.sh)!

The problem is that, unfortunately, GitHub Actions is **NOT** secure by default[^1].
One would think that when following the official documentation you end up with workflows that are secure and can not be exploited.
I was quite surprised to find out that this is not the case.
Last year, I came across [`zizmor`](https://zizmor.sh) and upon checking my workflows it pointed out several problems that I was quite surprised to find out about.

Of course, GitHub should make Actions more secure by default[^2].
It seems that the latest developments have lit a fire over there.
They have published a [security roadmap for GitHub Actions](https://github.blog/news-insights/product-news/whats-coming-to-our-github-actions-2026-security-roadmap/) and are [looking for feedback from the community](https://github.com/orgs/community/discussions/190621).

Until that happens, what can you do right now to harden your GitHub Actions workflows?

<!-- more -->

## Add `zizmor` to your project

Start by running it locally to address the findings:

```shell
uvx zizmor .
```

You can find alternative ways to [install](https://docs.zizmor.sh/installation/) and [run `zizmor`](https://docs.zizmor.sh/usage/) in the documentation.

At the same time, `zizmor` should run as a pre-commit hook and in CI as well so that future updates don't introduce vulnerabilities again.

=== ".pre-commit-config.yaml"

    ```yaml
      - repo: https://github.com/woodruffw/zizmor-pre-commit
        rev: <version>
        hooks:
          - id: zizmor
    ```

=== "Github Actions"

    You can either run the pre-commit hooks in CI which is a good thing to ensure consistency across local development and CI:

    ```yaml
      - uses: j178/prek-action@79f765515bd648eb4d6bb1b17277b7cb22cb6468 # v2.0.0 (1)
        with:
          prek-version: <version>
    ```

    1. At the time of writing, this is the current version, please update it if there's a newer one and pin to the commit SHA.

    `zizmor` also provides a handy [GitHub Action](https://docs.zizmor.sh/integrations/#github-actions) that you can integrate into your workflow.

    There are more ways, see the [integrations documentation](https://docs.zizmor.sh/integrations/).

!!! tip "Use `actionlint` in addition to `zizmor`"

    At the same time, I also suggest to use [`actionlint`](https://github.com/rhysd/actionlint) with the `shellcheck` integration.
    It provides a lot of [checks](https://github.com/rhysd/actionlint/blob/main/docs/checks.md) that complement `zizmor`.
    In particular, it has a [`shellcheck` integration](https://github.com/rhysd/actionlint/blob/main/docs/checks.md#check-shellcheck-integ).

    You can add it as a pre-commit hook as well, either using the container image, or via the Go module:

    === "`actionlint-docker`"

        ```yaml title=".pre-commit-config.yaml"
        - repo: https://github.com/rhysd/actionlint
        rev: <version>
        hooks:
            - id: actionlint-docker
        ```

        The container image includes `shellcheck` which is run by default.

    === "Additional `shellcheck` dependency"

        ```yaml title=".pre-commit-config.yaml"
        - repo: https://github.com/rhysd/actionlint
        rev: <version>
        hooks:
            - id: actionlint
            language: golang
            additional_dependencies:
                # see also: https://github.com/rhysd/actionlint/pull/482
                - "github.com/wasilibs/go-shellcheck/cmd/shellcheck@<version>"
        ```

        See my blog post about [renovating additional hook dependencies](./renovating-pre-commit-additional-dependencies.md) to ensure that the `shellcheck` dependency also receives dependency updates.

    Note that there is no official GitHub Action provided for `actionlint`.

Hardening GitHub Actions workflows is something that especially open source projects should do.
And this would have certainly helped `trivy` and others not to have their secrets stolen and malicious new versions published.
But what if you were _just_ a user of `trivy`.
How could you have avoided (or delayed) getting the malicious version?

The answer is: Dependency pinning.

## Dependency Pinning

Dependency pinning is absolutely essential to get reproducible builds, development environments etc.
Whenever you install, you know exactly which version of direct and transitive (via lock files) dependency versions you get.
Renovate has a [guide on dependency pinning](https://docs.renovatebot.com/dependency-pinning/) that I recommend.

If you are still not convinced, look at what happened with the [`litellm` compromise](https://www.stepsecurity.io/blog/litellm-credential-stealer-hidden-in-pypi-wheel).
Based on [analysis by futuresearch](https://futuresearch.ai/blog/litellm-hack-were-you-one-of-the-47000/), in the 46 minutes that the two malicious versions were available on PyPI, `litellm` was downloaded over 46000 times!

Only [9% out of the over 2000 packages they analyzed](https://futuresearch.ai/blog/litellm-hack-were-you-one-of-the-47000/#:~:text=Version%20pinning%20determines%20exposure) pinned to an exact version.
88% of dependants would have received a malicious versions if they installed `litellm` during the attack window.

The [`trivy` attack](https://www.wiz.io/blog/trivy-compromised-teampcp-supply-chain-attack) is similar.
In addition, the attacker also force-pushed tags of their actions to malicious versions.
It required pinning to a commit SHA hash to be unaffected since existing version tags were changed by the malicious actor.
Another attack with an action happened [last year with `tj-actions/changed-files`](https://unit42.paloaltonetworks.com/github-actions-supply-chain-attack/).

So pinning to an exact version is not sufficient, and pinning to a commit SHA is definitely something one should do.

!!! note

    Maintainers should definitely [enable immutable releases][immutable-releases] on their repository/organization to prevent tags from being changed.

No one likes updating dependencies manually, and you don't have to.
Thankfully, there are fantastic tools like [Renovate](https://docs.renovatebot.com) available to use (and free and open source!).

Renovate provides a helper preset [`helpers:pinGitHubActionDigestsToSemver`](https://docs.renovatebot.com/presets-helpers/#helperspingithubactiondigeststosemver) that can pin an action to a digest (commit hash) of a semantic version.
It also includes the version in a comment which is very helpful.

Here is an example with `actions/checkout`, probably the most used action:

=== "Before :warning:"

    ```yaml
    steps:
      - name: Checkout repository
        uses: actions/checkout@v6.0.1
        with:
          persist-credentials: false
    ```

=== "After :white_check_mark:"

    ```yaml
    steps:
      - name: Checkout repository
        uses: actions/checkout@8e8c483db84b4bee98b60c0593521ed34d9990e8 # v6.0.1
        with:
          persist-credentials: false
    ```

When a new version of `actions/checkout` is published, Renovate [will create a PR](https://github.com/mschoettle/website/pull/203) for you with the following diff:

```diff
     steps:
       - name: Checkout repository
-        uses: actions/checkout@8e8c483db84b4bee98b60c0593521ed34d9990e8 # v6.0.1
+        uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6.0.2
         with:
           persist-credentials: false
```

`zizmor` actually has an [`unpinned-uses` rule](https://docs.zizmor.sh/audits/#unpinned-uses) which since version `v1.20.0` ensures you use hash-pinning.

For all other dependencies, Renovate provides the [`:pinAllExceptPeerDependencies`](https://docs.renovatebot.com/presets-default/#pinallexceptpeerdependencies).

## Dependency cooldowns

With all this, it is of course still possible to be trigger happy and merge the Renovate PR to update to a new version right away.

_William Woodruff_, the author of `zizmor`, [made the case for dependency cooldowns](https://blog.yossarian.net/2025/11/21/We-should-all-be-using-dependency-cooldowns).
And _Andrew Nesbitt_ followed this up with a [post looking at support for cooldowns in package managers][package-managers-cooldown].

Sticking with using Renovate in this post[^3], we can make use of Renovate's [`minimumReleaseAge` feature](https://docs.renovatebot.com/key-concepts/minimum-release-age/):

```json title="reonvate.json5"
{
  "minimumReleaseAge": "7 days",
  "internalChecksFilter": "strict"
}
```

They provide a [preset specific to npm](https://docs.renovatebot.com/presets-security/#securityminimumreleaseagenpm) that sets `minimumReleaseAge` to 3 days.
With the above configuration, every dependency needs to have been released at least 7 days before.

!!! note "Lock files"

    Renovate currently does not use this to restrict [transitive dependencies in lock files](https://docs.renovatebot.com/key-concepts/minimum-release-age/#what-happens-to-transitive-dependencies).
    However, there is an [open issue to use minimum release age for package managers](https://github.com/renovatebot/renovate/issues/41652).
    To do it manually, refer to the comparison of [support for a cooldown across package managers][package-managers-cooldown].

Doing all this will give you hardened workflows and prevent you from unwillingly installing malicious versions (or at least slow the probability down).
Finally, if you are a maintainer, please enable [immutable releases][immutable-releases], and use [trusted publishing](https://repos.openssf.org/trusted-publishers-for-all-package-repositories.html).

Do you know if anything else that can be done?
Please let me know!

[^1]: Look through the [audit rules of `zizmor`](https://docs.zizmor.sh/audits/) to get an idea.

[^2]: See a [LinkedIn post by Dan Lorenc](https://www.linkedin.com/feed/update/urn:li:activity:7441468565012054016/) (the CEO of [Chainguard](https://www.chainguard.dev)) on what GitHub would need to do to make actions more secure by default.

[^3]: Dependabot has a cooldown feature which [`zizmor` tells you about](https://docs.zizmor.sh/audits/#dependabot-cooldown).

[immutable-releases]: https://docs.github.com/en/code-security/concepts/supply-chain-security/immutable-releases
[package-managers-cooldown]: https://nesbitt.io/2026/03/04/package-managers-need-to-cool-down.html
