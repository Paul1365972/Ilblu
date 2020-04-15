#!/usr/bin/env bash

(
set -euo pipefail
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false"

echo "Loading upstream..."

cd "$basedir/"
$gitcmd submodule update --init --recursive --remote

echo "Patching parent"
cd "$basedir/Paper/"
./paper patch

echo "Finished upstream"
)
