#!/bin/bash

set -e

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$1" != "--skip-tests" -a "$1" != "-s"  ]; then
    echo "Running tests"
    "$SCRIPTS_DIR/run-tests.sh"
fi

sudo s2i build "$SCRIPTS_DIR/.." centos/ruby-24-centos7-subtitle-mixer subtitle-mixer
