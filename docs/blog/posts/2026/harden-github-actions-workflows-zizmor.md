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

# Harden your GitHub Actions Workflows with `zizmor` and dependency pinning

It's been a crazy week (or weeks?) with [several supply chain attacks](https://ramimac.me/teampcp/).
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
Based on [analysis by futuresearch](https://futuresearch.ai/blog/litellm-hack-were-you-one-of-the-47000/) in the 46 minutes that the two malicious versions were available on PyPI, `litellm` was downloaded over 46000 times!

Only [9% out of the over 2000 packages they analyzed](https://futuresearch.ai/blog/litellm-hack-were-you-one-of-the-47000/#:~:text=Version%20pinning%20determines%20exposure) pinned to an exact version.
88% of dependants would have received a malicious versions if they installed during the attack window.

The `trivy` attack is similar but required pinning to a commit SHA hash to be unaffected since version tags were changed by the malicious actor.

No one likes updating dependencies manually, and thankfully they are fantastic tools like [Renovate](https://docs.renovatebot.com) available to (and free!) to use.

## Links

- https://www.chainguard.dev/unchained/how-to-protect-your-organization-from-the-telnyx-pypi-compromise
- https://ramimac.me/teampcp/#phase-10
- Dan Lorenc: Tips to make it harder for something like the Aqua breach from happening to you: https://www.linkedin.com/feed/update/urn:li:activity:7441841917555965953/?originTrackingId=YoN03WUMyBcfCsJ6xKJhEQ%3D%3D
- Dan Lorenc: making actions more secure by default: https://www.linkedin.com/feed/update/urn:li:activity:7441468565012054016/
- https://futuresearch.ai/blog/litellm-pypi-supply-chain-attack/
- https://github.blog/news-insights/product-news/whats-coming-to-our-github-actions-2026-security-roadmap/
    - Feedback & Suggestions: https://github.com/orgs/community/discussions/190621
- https://github.com/kahalewai/ai-scs/blob/main/teampcp-supply-chain-attack-infographic-final.svg
- https://www.stepsecurity.io/blog/hackerbot-claw-github-actions-exploitation#attack-2-project-akriakri---direct-script-injection
- https://www.stepsecurity.io/blog/teampcp-plants-wav-steganography-credential-stealer-in-telnyx-pypi-package
- https://www.wiz.io/blog/threes-a-crowd-teampcp-trojanizes-litellm-in-continuation-of-campaign

[^1]: Look through the [audit rules of `zizmor`](https://docs.zizmor.sh/audits/) to get an idea.

[^2]: See a [LinkedIn post by Dan Lorenc](https://www.linkedin.com/feed/update/urn:li:activity:7441468565012054016/) (the CEO of [Chainguard](https://www.chainguard.dev)) on what GitHub would need to do to make actions more secure by default.
