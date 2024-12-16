---
migrated: true
date:
  created: 2015-06-19
  updated: 2019-10-28
categories:
  - Git
#   - Howto
slug: move-directory-from-one-repository-to-another-preserving-history
---
# Move directory from one repository to another, preserving history

--8<-- "docs/snippets/archive.md"

I just moved one directory within a Git repository to a directory within another repository including its history.
For example:

```shell
.
├── repositoryA
│   ├── directoryToKeep
│   ├── otherDirectory
│   └── someFile.ext
└── repositoryB
    └── someStuff
```

<!-- more -->

The goal is to move `directoryToKeep` into `repositoryB` with its history, i.e., all commits that affect `directoryToKeep`.
If instead, you want to create a repository just for the contents of `directoryToKeep`, just skip the last step of the preparation of the source repository.

If you have files tracked by `git-lfs`, please note the update at the bottom first.

Here is how I did it, based on this [blog post](https://gbayer.com/development/moving-files-from-one-git-repository-to-another-preserving-history/) and [StackOverflow topic](https://stackoverflow.com/questions/1365541/how-to-move-files-from-one-git-repo-to-another-not-a-clone-preserving-history):

## Prepare the source repository

1. Clone `repositoryA` (make a copy, don't use your already existing one)
2. `cd` to it
3. Delete the link to the original repository to avoid accidentally making any remote changes

    ```shell
    git remote rm origin
    ```

4. Using `filter-branch`, go through the complete history and remove all commits (or keep all commits affecting `directoryToKeep`) not related to `directoryToKeep`.

    ```shell
    git filter-branch --subdirectory-filter <directoryToKeep> -- --all
    ```

    From the [git documentation](https://git-scm.com/docs/git-filter-branch):

    QUOTE: Only look at the history which touches the given subdirectory.
    The result will contain that directory (and only that) as its project root.

    You might need to add `--prune-empty` to avoid empty commits, in my case it was not necessary.

    This means that the result will be `repositoryA` containing the contents of `directoryToKeep` directly, which is also reflected in all the commits.
    If you want to create a separate repository just for `directoryToKeep`, skip the next step.
    If instead you want to move `directoryToKeep` to `repositoryB` into its own directory, you basically have two options.
    You might be fine with the way the commits are and create an additional commit that moves all files into a directory.
    However, if you are a perfectionist like myself, you can perform the following command to move `directoryToKeep` into its own directory, which will update all remaining commits accordingly.

5. Replace `directoryToKeep` with your actual directory before, and execute the following command [using `index-filter` this time](https://stackoverflow.com/a/12327345):

    ```shell
    git filter-branch --index-filter '
        git ls-files -sz |
        perl -0pe "s{\t}{\tdirectoryToKeep/}" |
        GIT_INDEX_FILE=$GIT_INDEX_FILE.new \
            git update-index --clear -z --index-info &amp;&amp;
            mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"
    ' HEAD
    ```

    If you want to [preserve tags](https://git-scm.com/docs/git-filter-branch#Documentation/git-filter-branch.txt---tag-name-filterltcommandgt) and update them, you need to add `--tag-name-filter cat`.

    If you get the error "mv: cannot stat ‘.new’: No such file or directory", you need to add the `--prune-empty` option to `filter-branch` to avoid empty commits.

You might need to perform the following optional steps:

* There might be old untracked files.
You can clean up the repository with the following commands:

    ```shell
    git reset --hard
    git gc --aggressive
    git prune
    git clean -df
    ```

* If you just want a new repository for `directoryToKeep`, you should be able to just push it.
Otherwise follow the second step.
It's also good at this point to make sure that the result is correct, e.g., using `git log`.

## Merge into target repository

1. Clone `repository` (make a copy, don't use your already existing one)
2. `cd` into it
3. Create a remote connection to `repositoryA` as a branch in `repositoryB`.

    ```shell
    git remote add <branch-name-repoA> /path/to/repositoryA
    ```

4. Pull from the branch (this assumes you performed the changes above on `master`)

    ```shell
    git pull --allow-unrelated-histories <branch-name-repoA> master
    ```

    !!! note

        Because your branch and `master` don't have a common base, [git 2.9+](https://github.com/git/git/blob/master/Documentation/RelNotes/2.9.0.txt#L58-L68) will refuse to merge them without the `--allow-unrelated-histories` option.

5. It will create a merge commit to merge the current `HEAD` with your branch.
The editor for the commit message should appear.
Enter a meaningful commit message and proceed.
6. Now you're done and can push.
7. Personally, I would just delete the cloned repositories from step 1 and go back to the actual repository.
8. If everything works, remove `directoryToKeep` from `repositoryA`.

> UPDATES: **Updates to this blog post**
>
> * **19.01.2017:** Updated step 2.4 with additional option (Thanks, Paul!)
> * **18.12.2018:** Updated step 1.5 with additional option to preserve tags (Thanks, Sandip!)
> * **28.10.2019:** If you have files tracked by `git-lfs`, there are is an additional step you need to perform
> After cloning the repository at the beginning, perform `git lfs fetch --all` ([source](https://stackoverflow.com/a/49366471)).
> As Evan pointed out in the comments, if the directory that should be kept does not have any large files, he performed `git lfs uninstall --local` to get rid of them.
