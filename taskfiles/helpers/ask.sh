#!/bin/bash
set -e

read -p "${1}"? -n 1 -r
if [[ ! $REPLY =~ ^[Yy] ]]; then
    echo -e "\n<<<<<<< ABORTING >>>>>>>"
    exit 1
fi
