# SPDX-FileCopyrightText: 2023 Alec Delaney, for Adafruit Industries
#
# SPDX-License-Identifier: MIT

"""
Script for checking the packaging of libraries.

Author(s): Alec Delaney, for Adafruit Industries
"""

import pathlib
import sys
import tomllib
from collections.abc import Iterable

with open("pyproject.toml", mode="rb") as tomlfile:
    settings = tomllib.load(tomlfile)

is_package = settings["tool"]["setuptools"].get("packages") is not None
libnames: Iterable[str] = (
    settings["tool"]["setuptools"]["packages"]
    if is_package
    else settings["tool"]["setuptools"]["py-modules"]
)

for libname in libnames:
    library_path = pathlib.Path(libname)
    if library_path.is_dir() != is_package:
        REQUIRED_CHANGE = "package" if library_path.is_dir() else "module"
        print(
            f"Library {libname} should be specified as a {REQUIRED_CHANGE} in pyproject.toml!"
        )
        sys.exit(1)
