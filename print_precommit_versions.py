# SPDX-FileCopyrightText: 2023 Alec Delaney, for Adafruit Industries
#
# SPDX-License-Identifier: MIT

"""
Script for printing the versions of the contents of .pre-commit-config.yaml

Author(s): Alec Delaney, for Adafruit Industries
"""

from typing import TypedDict
import yaml


class PreCommitRepo(TypedDict):
    """Typed dictionary structure of a pre-commit hook"""

    repo: str
    rev: str
    hooks: list[dict[str, str]]


with open(".pre-commit-config.yaml", mode="r", encoding="utf-8") as yamlfile:
    repos: list[PreCommitRepo] = yaml.safe_load(yamlfile)["repos"]

print("Using the following pre-commit hook versions:")
for repo in repos:
    print(f' * {repo["repo"]} @ {repo.get("rev")}')
