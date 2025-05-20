#!/bin/bash

# This script pushes a change to the lean-toolchain so we can test the latest revision of the current action.

if ! [ -z "$(git diff HEAD)" ]; then
  echo "Uncommitted changes: please commit them or stash them before testing!"
  exit 1
fi

revision_to_test=$(git rev-parse HEAD)

# Switch to testing branch and get latest action version.
git checkout testing
git merge main

mkdir -p .github/workflows
echo "
on:
  push:
    branches:
      - 'testing'
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
      uses: leanprover-community/lean-release-tag@$revision_to_test
      with:
        before: \${{ github.event.before }}
        after: \${{ github.event.after }}
" > .github/workflows/lean-release-tag.yml
git add .github/workflows/lean-release-tag.yml

# Test with one toolchain bump.
echo "leanprover/lean4:v4.$RANDOM.0" > lean-toolchain
git add lean-toolchain
git commit -m "Testing..."
git push

# Test with two toolchain bumps.
echo "leanprover/lean4:v4.$RANDOM.0" > lean-toolchain
git add lean-toolchain
git commit -m "Testing 1"
echo "leanprover/lean4:v4.$RANDOM.0" > lean-toolchain
git add lean-toolchain
git commit -m "Testing 2"
git push

# Test with extra newline at the end of the file.
echo "leanprover/lean4:v4.$RANDOM.0" > lean-toolchain
echo >> lean-toolchain
git add lean-toolchain
git commit -m "Testing with newlines"
# Test with no newline at the end of the file.
echo -n "leanprover/lean4:v4.$RANDOM.0" > lean-toolchain
git add lean-toolchain
git commit -m "Testing with no newlines"
git push

# Back to original branch.
git checkout main
