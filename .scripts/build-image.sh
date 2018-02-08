#!/bin/bash

set -e

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo docker build "$SCRIPTS_DIR" --tag centos/ruby-24-centos7-subtitle-mixer
