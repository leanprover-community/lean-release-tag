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
        do-release: true
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Configuration

### Inputs: `do-release`

This determines whether to create a GitHub release for the new tag. Allowed values: `true` and `false`. Default value: `false`.

### Inputs: `GITHUB_TOKEN`

This is the token used to access the GitHub API. The token is required to make releases. When in doubt, set this to the value of `secrets.GITHUB_TOKEN`.

### Inputs: `before` and `after`

These are the commit hashes of the most recent commit before and after the push, respectively. Any new Lean versions between `before` (exclusive) and `after` (inclusive) will get a tag. If this action runs on `push` (as in the expected configuration), you do not need to set these.

## Testing

To semi-manually test this action, run the `test-me.sh` script. This will make some example commits to the repository. Please verify that the corresponding tags have been created correctly.
