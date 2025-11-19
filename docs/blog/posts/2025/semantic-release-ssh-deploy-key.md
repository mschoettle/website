---
date:
  created: 2025-11-19
---

# Using `semantic-release` with an SSH deploy key in GitHub Actions

We use [`semantic-release`](https://semantic-release.gitbook.io/semantic-release/) to release new versions of one of our JavaScript-based web applications.
`semantic-release` can help with various release-based activities, such as figuring out the version bump based on the commit history using [conventional commits](https://www.conventionalcommits.org/), updating the changelog, pushing a new version tag, and so on.

We recently migrated our repositories to GitHub and have a ruleset enabled for the `main` (default) branch.
Using a [ruleset](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets) is basically the new way of [protecting a branch](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-status-checks-before-merging).
For a single developer or a very small team this might be overkill and slow you down.
For bigger teams definitely it makes sense to ensure that certain practices are adhered to.
For example, you can enforce that force pushes are getting blocked, or that a [pull request is required before merging](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets#require-a-pull-request-before-merging).

This is where we ran into issues where the release commit by `semantic-release` could not be pushed directly to `main` due to this rule.
GitHub allows you to [grant bypass permissions](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository#granting-bypass-permissions-for-your-branch-or-tag-ruleset) for your ruleset.
Unfortunately, you cannot add a single user to this bypass list, and the `GITHUB_TOKEN` secret is associated with the (special) `github-actions[bot]` user.

So, how were we able to accomplish this?

<!-- more -->

You could use another account, or a bot user with their own personal access token (PAT), or, create a dedicated GitHub app.
What we ended up using is a [deploy key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#deploy-keys).

The advantage of using a _deploy key_ is that it is tied to a specific repository whereas a user account might have access to more repositories.

To use and set up a deploy key for a repository, follow [GitHub's instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#set-up-deploy-keys).

Then, add "Deploy Keys" to the bypass list and set this specific bypass permission to "Always allow".

Now, to make use of this deploy key in your release workflow, you need to checkout the repository using the SSH private key.
Add the private key as an [actions secret on the repository](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets#creating-secrets-for-a-repository).

Then, update your workflow as follows:

```yaml title="Release workflow file"
[...]
    steps:
      - uses: actions/checkout@v5.0.0
        with:
          ssh-key: ${{ secrets.DEPLOY_KEY }}
          # Persist credentials so that semantic-release will use them
          persist-credentials: true
      - name: Run semantic-release
        run: npx semantic-release
[...]
```

And, you need to ensure that `semantic-release/git` plugin will use the SSH protocol.
Add the SSH repository URL to your `semantic-release` configuration in the [`repositoryUrl` option](https://semantic-release.gitbook.io/semantic-release/usage/configuration#repositoryurl):

```json title=".releaserc"
{
    "repositoryUrl": "git@github.com/owner/repo.git"
}
```

!!! tip Improving the `semantic-release` documentation

    Part of this was not immediately clear from the `semantic-release` documentation.
    I raised a PR to improve the SSH key documentation: https://github.com/semantic-release/semantic-release/pull/3950
