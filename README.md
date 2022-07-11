<!--
SPDX-FileCopyrightText: 2019 Adafruit Industries

SPDX-License-Identifier: MIT
-->

# Actions CI CircuitPython Install Script

The purpose of this repo is to create a centrally managed dependency
install script for all Adafruit CircuitPython Library Github Actions.
This will allow us to easily update the install steps without
having to manually or programatically update 200+ GitHub workflows.

We have [a Learn guide](https://learn.adafruit.com/creating-and-sharing-a-circuitpython-library/testing-with-github-actions)
that you can use to follow along to using GitHub Actions.

# Using in Workflow Files

To use the install script in workflow files, you'll need to check out this
repository, followed by running the `install.sh` bash script.

You can clone and checkout this repo in a GitHub Actions workflow file using
`actions/checkout`:

```yaml
- name: Checkout tools repo
  uses: actions/checkout@v2
  with:
    repository: adafruit/actions-ci-circuitpython-libs
    path: actions-ci
```

In the example above, the repo is now cloned as `actions-ci`.

The dependencies can then be downloaded using `install.sh`:

```yaml
- name: Install dependencies
  run: |
    source action-ci/install.sh
```

This will handle installing all the needed dependencies for the given library.
