---
categories:
  - CI/CD
date:
  created: 2026-03-28
  updated: 2026-03-31
tags:
  - automation
  - code quality
  - github actions
  - security
---

# Harden your GitHub Actions Workflows with `zizmor`, dependency pinning, and dependency cooldowns

It's been a crazy week (or weeks?) for a lot of people with [several supply chain attacks](https://ramimac.me/teampcp/).
They all seem to have originated from the [compromise of `trivy`](https://www.stepsecurity.io/blog/trivy-compromised-a-second-time---malicious-v0-69-4-release) (ironically, `trivy` is a security scanner).
I wanted to understand how they initially gained access to the secrets used in their GitHub organization and found that there was an [earlier attack that targeted GitHub Actions workflows of open source projects](https://www.stepsecurity.io/blog/hackerbot-claw-github-actions-exploitation).

Looking at the details of how the secrets were extracted I noticed that they all used similar techniques.
And, unless I missed something, it is through template injection and unsafe `pull_request_target` triggers.
This could be avoided because all of those vulnerabilities (and more) can be found by [`zizmor`][zizmor], a static analysis tool for GitHub Actions!

The problem is that, unfortunately, GitHub Actions is **NOT** secure by default[^1].
One would think that when following the official documentation you end up with workflows that are secure and can not be exploited.
Last year, I came across [`zizmor`][zizmor] and upon checking my workflows it pointed out several problems that I was quite surprised to find out about.

Of course, GitHub should make Actions more secure by default[^2].
And it seems that the latest attacks have finally helped to make some progress in that direction.
GitHub have published a [security roadmap for GitHub Actions][github-security-roadmap] and are [looking for feedback from the community][github-security-roadmap-discussion].

Until that happens, what can you do right now to harden your GitHub Actions workflows?

<!-- more -->

## Add `zizmor` to your project

Start by running it locally to address findings:

```shell
uvx zizmor .
```

You can find alternative ways to [install](https://docs.zizmor.sh/installation/) and [run `zizmor`](https://docs.zizmor.sh/usage/) in the documentation.

At the same time, `zizmor` should run as a pre-commit hook and in CI as well so that future changes to your workflows don't introduce vulnerabilities again.

=== ".pre-commit-config.yaml"

    ```yaml
      - repo: https://github.com/woodruffw/zizmor-pre-commit
        rev: <version>
        hooks:
          - id: zizmor
    ```

=== "Github Actions"

    You can run the pre-commit hooks in CI (which is a good thing to ensure consistency across local development and CI):

    ```yaml
      - uses: j178/prek-action@79f765515bd648eb4d6bb1b17277b7cb22cb6468 # v2.0.0 (1)
        with:
          prek-version: <version>
    ```

    1. At the time of writing, this is the current version, please update it if there's a newer one and pin to the commit SHA.

    Or, `zizmor` also provides a handy [GitHub Action](https://docs.zizmor.sh/integrations/#github-actions) that you can integrate into your workflow.

    See the [integrations documentation](https://docs.zizmor.sh/integrations/) for more ways to integrate `zizmor`.

!!! tip "Use `actionlint` in addition to `zizmor`"

    At the same time, I also suggest to use [`actionlint`][actionlint] with the `shellcheck` integration.
    It provides a lot of [checks][actionlint-checks] that complement `zizmor`.
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
    Only some third-party ones.

Hardening GitHub Actions workflows is something that especially open source projects should do.
And this would have certainly helped `trivy` and others not to have their secrets stolen and malicious new versions published.
But what if you were _just_ a user of `trivy`.
How could you have avoided (or delayed) getting the malicious version?

The answer is: Dependency pinning.

## Dependency Pinning

Dependency pinning is absolutely essential to get reproducible builds, development environments etc.
Whenever you install dependencies or run a build, you know exactly which version of direct and transitive (via lock files) dependency versions you get.
Renovate has a [guide on dependency pinning](https://docs.renovatebot.com/dependency-pinning/) that I recommend.

If you are still not convinced, look at what happened with the [`litellm` compromise](https://www.stepsecurity.io/blog/litellm-credential-stealer-hidden-in-pypi-wheel).
Based on [analysis by futuresearch](https://futuresearch.ai/blog/litellm-hack-were-you-one-of-the-47000/), in the 46 minutes that the two malicious versions were available on PyPI, `litellm` was downloaded over 46000 times!

Only [9% out of the over 2000 packages they analyzed](https://futuresearch.ai/blog/litellm-hack-were-you-one-of-the-47000/#:~:text=Version%20pinning%20determines%20exposure) pinned to an exact version.
88% of dependants would have received a malicious versions if they installed `litellm` during the attack window.

The [`trivy` attack](https://www.wiz.io/blog/trivy-compromised-teampcp-supply-chain-attack) is similar.
In addition, the attacker also force-pushed tags of their actions to malicious versions.
It required pinning to a commit SHA hash to be unaffected since existing version tags were changed by the malicious actor.
Another attack with an action happened [last year with `tj-actions/changed-files`](https://unit42.paloaltonetworks.com/github-actions-supply-chain-attack/).

So pinning to an exact version is not sufficient.
You need to pin to a commit SHA.

!!! note

    Maintainers should [enable immutable releases][immutable-releases] on their repository/organization to prevent tags from being changed.
    Unfortunately, this is not enabled by default.

No one likes updating dependencies manually, and you don't have to.
Thankfully, there are fantastic tools like [Renovate](https://docs.renovatebot.com) available to use (and free and open source!).

Renovate provides a helper preset [`helpers:pinGitHubActionDigestsToSemver`](https://docs.renovatebot.com/presets-helpers/#helperspingithubactiondigeststosemver) that can pin an action to a digest (commit hash) of a semantic version.
It also includes the version in a comment which is very helpful.

Here is an example with `actions/checkout` (probably the most used action out there?):

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

When a new version of `actions/checkout` is published, Renovate [will create a PR](https://github.com/mschoettle/website/pull/203) for you with a diff like this:

```diff
     steps:
       - name: Checkout repository
-        uses: actions/checkout@8e8c483db84b4bee98b60c0593521ed34d9990e8 # v6.0.1
+        uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6.0.2
         with:
           persist-credentials: false
```

`zizmor` actually has an [`unpinned-uses` rule](https://docs.zizmor.sh/audits/#unpinned-uses) which, since version `v1.20.0`, ensures you use hash-pinning.

For all other dependencies, Renovate provides the [`:pinAllExceptPeerDependencies`](https://docs.renovatebot.com/presets-default/#pinallexceptpeerdependencies).

## Dependency cooldowns

With all this, it is of course still possible to be quick and merge the dependency update PR to update to a new version right away.

_William Woodruff_, the author of `zizmor`, [made the case for dependency cooldowns][dependency-cooldowns].
And _Andrew Nesbitt_ followed this up with a [post looking at support for cooldowns in package managers][package-managers-cooldown].

Sticking with the Renovate example of this post[^3], we can make use of Renovate's [`minimumReleaseAge` feature][renovate-minimumreleaseage][^4]:

```json title="reonvate.json5"
{
  "minimumReleaseAge": "7 days",
  "internalChecksFilter": "strict"
}
```

With the above configuration, every dependency needs to have been released at least 7 days before.

!!! note "Lock files"

    Renovate currently does not use `minimumReleaseAge` to restrict [transitive dependencies in lock files](https://docs.renovatebot.com/key-concepts/minimum-release-age/#what-happens-to-transitive-dependencies).
    However, there is an [open issue to use minimum release age for package managers](https://github.com/renovatebot/renovate/issues/41652).
    To do it manually, refer to the comparison of [support for a cooldown across package managers][package-managers-cooldown].

Doing all this will give you hardened workflows and prevent you from unwillingly installing malicious versions (or at least decrease the probability of this happening quite a bit).
Finally, if you are a maintainer of a package, please enable [immutable releases][immutable-releases], and use [trusted publishing][trusted-publishing].

Hope this helps!
Do you know of anything else that can be done?
Please let me know.

!!! note "Updates to this blog post"

    - **30.03.2026:** This post was featured on [episode 475 of the Python Bytes Podcast](https://pythonbytes.fm/episodes/show/475/haunted-warehouses)
    - **31.03.2026:** Added a dedicated references section to show links of this article more prominently

## References

- Github Documentation: [Immutable releases][immutable-releases]
- Post: [Package Managers Need to Cool Down][package-managers-cooldown]
- Post: [We should all be using dependency cooldowns][dependency-cooldowns]
- Renovate Documentation: [Minimum Release Age][renovate-minimumreleaseage]
- Zizmor
    - [Website][zizmor]
    - [Audit Rules documentation][zizmor-audits]
- Actionlint
    - [GitHub Repository][actionlint]
    - [Checks](https://TODO)
- Post: [Trusted Publishers for All Package Repositories][trusted-publishing]
- GitHub Blog: [What’s coming to our GitHub Actions 2026 security roadmap][github-security-roadmap]
    - Provide feedback: [What’s coming to our GitHub Actions 2026 security roadmap - Feedback & Suggestions][github-security-roadmap-discussion]

[^1]: Look through the [audit rules of `zizmor`][zizmor-audits] to get an idea.

[^2]: See a [LinkedIn post by Dan Lorenc](https://www.linkedin.com/feed/update/urn:li:activity:7441468565012054016/) (the CEO of [Chainguard](https://www.chainguard.dev)) on what GitHub would need to do to make actions more secure by default.

[^3]: Dependabot has a cooldown feature which [`zizmor` tells you about](https://docs.zizmor.sh/audits/#dependabot-cooldown).

[^4]: Renovate also provides a [preset specific to npm](https://docs.renovatebot.com/presets-security/#securityminimumreleaseagenpm) that sets `minimumReleaseAge` to 3 days.

[actionlint]: https://github.com/rhysd/actionlint
[actionlint-checks]: https://github.com/rhysd/actionlint/blob/main/docs/checks.md
[dependency-cooldowns]: https://blog.yossarian.net/2025/11/21/We-should-all-be-using-dependency-cooldowns
[github-security-roadmap]: https://github.blog/news-insights/product-news/whats-coming-to-our-github-actions-2026-security-roadmap/
[github-security-roadmap-discussion]: https://github.com/orgs/community/discussions/190621
[immutable-releases]: https://docs.github.com/en/code-security/concepts/supply-chain-security/immutable-releases
[package-managers-cooldown]: https://nesbitt.io/2026/03/04/package-managers-need-to-cool-down.html
[renovate-minimumreleaseage]: https://docs.renovatebot.com/key-concepts/minimum-release-age/
[trusted-publishing]: https://repos.openssf.org/trusted-publishers-for-all-package-repositories.html
[zizmor]: https://zizmor.sh
[zizmor-audits]: https://docs.zizmor.sh
