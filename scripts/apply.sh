#!/usr/bin/env bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

gitcmd="git -c commit.gpgsign=false"
applycmd="$gitcmd am --3way --ignore-whitespace"

echo "Rebuilding Forked projects.... "

function applyPatch {
    what=$1
    what_name=$(basename $what)
    target=$2
    branch=$3
    patch_folder=$4

    cd "$basedir/$what"
    $gitcmd fetch --all
    $gitcmd branch -f upstream "$branch" >/dev/null

    cd "$basedir"
    if [ ! -d  "$basedir/$target" ]; then
        mkdir "$basedir/$target"
        cd "$basedir/$target"
        $gitcmd init
        $gitcmd remote add origin "$5"
        cd "$basedir"
    fi
    cd "$basedir/$target"

    echo "Resetting $target to $what_name..."
    $gitcmd remote rm upstream > /dev/null 2>&1
    $gitcmd remote add upstream "$basedir/$what" >/dev/null 2>&1
    $gitcmd checkout master 2>/dev/null || git checkout -b master
    $gitcmd fetch upstream >/dev/null 2>&1
    $gitcmd reset --hard upstream/upstream
    echo "  Applying patches to $target..."
    $gitcmd am --abort >/dev/null 2>&1
    find "$basedir/patches/$patch_folder/" -name "*.patch" -exec $applycmd {} +
    if [ "$?" != "0" ]; then
        echo "  Something did not apply cleanly to $target."
        echo "  Please review above details and finish the apply then"
        echo "  save the changes with rebuildPatches.sh"
        exit 1
    else
        echo "  Patches applied cleanly to $target"
    fi
}

echo "Importing MC-DEV"
./scripts/importmcdev.sh "$basedir" || exit 1
(
    (applyPatch Paper/Paper-API ${FORK_NAME}-API HEAD api $API_REPO &&
    applyPatch Paper/Paper-Server ${FORK_NAME}-Server HEAD server $SERVER_REPO) || exit 1
) || (
    echo "Failed to apply patches"
    exit 1
) || exit 1
