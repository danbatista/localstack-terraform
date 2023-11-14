#!/usr/bin/env sh

set -x

tflocal init; tflocal plan; tflocal apply --auto-approve