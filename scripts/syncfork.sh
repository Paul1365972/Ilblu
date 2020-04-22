#!/usr/bin/env bash

(
set -euo pipefail
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false"

echo "Syncing fork..."

cd "$basedir/"
oldhash=$($gitcmd rev-parse HEAD)
$gitcmd remote add upstream https://github.com/Paul1365972/Ilblu.git || true
$gitcmd fetch upstream
$gitcmd checkout master
$gitcmd merge upstream/master
$gitcmd submodule update --init --recursive
newhash=$($gitcmd rev-parse HEAD)

if [ "$oldhash" == "$newhash" ]; then
    echo "No changes for $newhash"
    exit 0
fi

"$basedir/scripts/initupstream.sh" "$basedir"
"$basedir/scripts/apply.sh" "$basedir"
"$basedir/scripts/rebuildpatches.sh" "$basedir"

changelog=$(cd "$basedir/Paper/" && $gitcmd log $oldhash...$newhash --pretty="%h %s")
$gitcmd add -A
$gitcmd commit --amend -m "Merge remote-tracking branch 'upstream/master'" -m "From $oldhash to $newhash" -m "$(echo -e "Ilblu changes:\n$changelog")"

echo "Finished sync"
)
