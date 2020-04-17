#!/usr/bin/env bash

(
set -euo pipefail
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false"

echo "Update parent..."

oldhash=$(cd "$basedir/Paper/" && $gitcmd rev-parse HEAD)

cd "$basedir/"
$gitcmd submodule update --remote --recursive --force

newhash=$(cd "$basedir/Paper/" && $gitcmd rev-parse HEAD)

if [ "$oldhash" == "$newhash" ]; then
    echo "No changes for $newhash"
    exit 0
fi

"$basedir/scripts/initupstream.sh" "$basedir"
"$basedir/scripts/apply.sh" "$basedir"
"$basedir/scripts/rebuildpatches.sh" "$basedir"

changelog=$(cd "$basedir/Paper/" && $gitcmd log $oldhash...$newhash --pretty="%h %s")
$gitcmd add -A
$gitcmd commit -m "Updated upstream (Paper)" -m "From $oldhash to $newhash" -m "$(echo -e "Paper changes:\n$changelog")"

echo "Finished updating parent"
)
