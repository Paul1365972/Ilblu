#!/usr/bin/env bash

(
set -euo pipefail
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false"

echo "Syncing fork..."

cd "$basedir/"
$gitcmd remote add upstream https://github.com/Paul1365972/Ilblu.git || true
$gitcmd fetch upstream
$gitcmd checkout master
$gitcmd merge upstream/master

"$basedir/scripts/apply.sh" "$basedir"
"$basedir/scripts/rebuildpatches.sh" "$basedir"

echo "Finished sync"
)
