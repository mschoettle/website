---
categories:
  - Git
date:
  created: 2026-10-16
tags:
  - git
  - howto
---

# Delete local Git branches after squash merging

Squash merging pull requests seems to be the only sensible way to do things.
This allows a developer to make as many commits to a branch that they want,
and address code review feedback.
At the same time, it helps the reviewer because the PR author does not need to constantly rebase a branch.
Doing so would hinder a reviewer to know what has changed since the last review.

Git unfortunately gets confused because it cannot know which commits have been merged.
Squash merging a branch results in a single commit with a new identity.

I try to make many small pull requests each containing a logical change.
This has many benefits.

Every once in a while I notice how many local branches I have and need to do a cleanup.
Here is how:

This only works if remote branches are deleted after merging a pull request.
For example, on GitHub this can be done automatically via a repository setting.

First, prune the remotes:

```shell
git fetch --prune
```

Now, find all branches whose remote is gone:

```shell
git branch --verbose | grep "\[gone\]" | awk '{print $1}' | xargs git branch --delete
```

Git will give you an error because it thinks that the branches have unmerged commits.
This step is just to ensure that the right branches are found.
You don't want to delete a branch you want to keep by accident.

When you are satisfied, append `--force`:

```shell
git branch --verbose | grep "\[gone\]" | awk '{print $1}' | xargs git branch --delete --force
```
