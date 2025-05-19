# Tag Lean releases in your project

This is an action that creates a Git tag when your project updates to a new Lean release.

It works by looking for changes to the `lean-toolchain` file in the Git history. For every new release that is found in this file, a tag is created on the first commit.

To enable this action, add it to a workflow that runs on `push` to your `main`/`master` branch. For example:
```yml
on:
  push:
    branches:
      - 'main'
      - 'master'
    paths:
      - 'lean-toolchain'

jobs:
  lean-release-tag:
    name: Add Lean release tag
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
    - name: lean-release-tag action
      uses: leanprover-community/lean-release-tag
      with:
        before: ${{ github.event.before }}
        after: ${{ github.event.after }}
```
