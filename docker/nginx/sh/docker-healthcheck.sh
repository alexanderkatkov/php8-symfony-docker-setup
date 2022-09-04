#!/bin/sh
set -e

curl --fail-with-body --insecure http://localhost/health-check || exit 1
curl --fail-with-body --insecure https://localhost/health-check || exit 1
