#!/bin/bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo s2i build "$SCRIPTS_DIR/.." centos/ruby-24-centos7-subtitle-mixer subtitle-mixer
