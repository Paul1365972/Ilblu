#!/usr/bin/env bash

# Copied from https://github.com/PaperMC/Paper/blob/089d83568b6876cd01eacdbe49aba34e14336ccf/scripts/applyPatches.sh
# License from Paper applies to this file

(
set -e
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false"
applycmd="$gitcmd am --3way --ignore-whitespace"

echo "Rebuilding Forked projects..."

function applyPatch {
    what=$1
    target=$2
    branch=$3
    patch_folder=$4

    cd "$basedir/$what/"
    $gitcmd fetch --all
    $gitcmd branch -f upstream "$branch" >/dev/null

    cd "$basedir/"
    if [ ! -d  "$basedir/$target" ]; then
        mkdir "$basedir/$target"
        cd "$basedir/$target/"
        $gitcmd init
        $gitcmd remote add origin "$5"
        cd "$basedir/"
    fi
    cd "$basedir/$target/"

    echo "Resetting $target to $what..."
    $gitcmd remote rm upstream > /dev/null 2>&1
    $gitcmd remote add upstream "$basedir/$what" >/dev/null 2>&1
    $gitcmd checkout master 2>/dev/null || git checkout -b master
    $gitcmd fetch upstream >/dev/null 2>&1
    $gitcmd reset --hard upstream/upstream

    echo "  Applying patches to $target..."

    statusfile=".git/patch-apply-failed"
    rm -f "$statusfile"
    $gitcmd am --abort >/dev/null 2>&1
    # TODO Optimise (currently we could also use git apply)
    find "$basedir/patches/$patch_folder/" -name "*.patch" -exec $applycmd {} \;
    if [ "$?" != "0" ]; then
        echo 1 > "$statusfile"
        echo "  Something did not apply cleanly to $target."
        echo "  Please review above details and finish the apply then"
        echo "  save the changes with rebuildPatches.sh"
        exit 1
    else
        rm -f "$statusfile"
        echo "  Patches applied cleanly to $target"
    fi
}

"$basedir/scripts/importmcdev.sh" "$basedir" || exit 1

(
    applyPatch Paper/Paper-API ${FORK_NAME}-API HEAD api $API_REPO &&
    applyPatch Paper/Paper-Server ${FORK_NAME}-Server HEAD server $SERVER_REPO

    # TODO this runs every time (and also twice)
    # if we have previously created mcdev, update it
    # if [ -d "$basedir/mc-dev" ]; then
    #     cd "$basedir/Paper/"
    #     parentVer=$($gitcmd rev-parse --short HEAD)
    #     cd "$basedir/Paper/Paper-Server/"
    #     minecraftversion=$(cat "$basedir/Paper/work/BuildData/info.json" | grep minecraftVersion | cut -d '"' -f 4)
    #     version=$(echo -e "Paper: $parentVer\nmc-dev:$importedmcdev")
    #     tag="$minecraftversion-$mcVer-$(echo -e $version | sha1sum | awk '{print $1}')"
    #     "$basedir/scripts/generatemcdevsrc.sh" "$basedir" "$tag"
    # fi
    echo "Patching finished"
) || (
    echo "Failed to apply patches"
    exit 1
) || exit 1
) || exit 1
