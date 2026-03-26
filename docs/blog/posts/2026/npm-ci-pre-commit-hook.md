---
date:
  created: 2026-03-26
tags:
  - automation
  - code quality
---

# Run `npm ci` as a pre-commit hook

This week I was updating a dependency in a node-based repository and several times forgot to commit the changes to `package-lock.json` as well.

The CI pipeline failed each time because it runs `npm ci` to ensure that the lock file is up to date.

I wondered whether I could catch this problem locally at commit-time via a pre-commit hook.

```yaml title=".pre-commit-config.yaml"
repos:
  - repo: local
    hooks:
      - id: npm-ci
        name: npm lockfile up to date
        language: node
        entry: npm ci --dry-run
        files: ^package(-lock)?\.json$
```

Actually, seeing this now makes me realize that `--dry-run` is unnecessary.
This way, the lock file gets modified (if it wasn't) and you can stage it for your commit.

Now, the CI job that runs pre-commit hooks via `prek` failed because the system `node` version is used by default.
At the time of this writing it has `v20` installed whereas our packages require `v22` or even `v24`.
There is a [`language_version` property](https://prek.j178.dev/languages/?h=language#language_version_5), however, since `npm ci` is already run in a job to actually install the dependencies.
So in the end, this hook is skipped in CI.
