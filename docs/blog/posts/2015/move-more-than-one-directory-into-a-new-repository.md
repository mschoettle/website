---
migrated: true
date:
  created: 2015-08-18
  updated: 2015-08-18
categories:
  - Git
#   - Howto
slug: move-more-than-one-directory-into-a-new-repository
---

# Move more than one directory into a new repository

--8<-- "docs/snippets/archive.md"

I just realized that my previous post on [how to move one directory from one repository](move-directory-from-one-repository-to-another-preserving-history.md) to another really only works for one directory.

Fortunately, there is a very easy solution to that using a nice little tool called [git_filter](https://github.com/slobobaby/git_filter).

Basically follow the instructions of it's `README`.
Then, all I did was put the two directories into the filter file.
It is important to note here that this file had to end with an empty line in my case, otherwise the last directory will be ignored.

You will get a new branch, which can be pushed to an empty repository:

```shell
git remote add origin_repoB <url of repo>
git push origin_repoB <localBranch>:master
```

It also works for one directory and is a lot faster compared to the other method.
