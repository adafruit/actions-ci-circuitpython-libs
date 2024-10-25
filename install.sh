#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2019 Adafruit Industries
#
# SPDX-License-Identifier: MIT

# we need bash 4 for associative arrays
if [ "${BASH_VERSION%%[^0-9]*}" -lt "4" ]; then
  echo "BASH VERSION < 4: ${BASH_VERSION}" >&2
  exit 1
fi

#This condition is to avoid reruning install when build argument is passed
if [[ $# -eq 0 ]] ; then
  # define colors
  GRAY='\033[1;30m'; RED='\033[0;31m'; LRED='\033[1;31m'; GREEN='\033[0;32m'; LGREEN='\033[1;32m'; ORANGE='\033[0;33m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; LBLUE='\033[1;34m'; PURPLE='\033[0;35m'; LPURPLE='\033[1;35m'; CYAN='\033[0;36m'; LCYAN='\033[1;36m'; LGRAY='\033[0;37m'; WHITE='\033[1;37m';
fi

# Install package dependencies
sudo apt-get update
sudo apt-get install libudev-dev libusb-1.0
sudo apt-get install -y gettext

# Install dependencies for these scripts
if test -d "actions-ci"; then
  pip install -r actions-ci/requirements.txt
else
  echo "Directory 'actions-ci' does not exist!"
  echo "CI expects the 'actions-ci-circuitpython-libs' tools being checked out to said directory."
  exit 1
fi

# Install dependencies for the library
pip install -r requirements.txt
if test -f "optional_requirements.txt"; then
    pip install -r optional_requirements.txt
fi
if test -f "docs/requirements.txt"; then
    pip install -r docs/requirements.txt
fi

# Install build tool
pip install circuitpython-build-tools
