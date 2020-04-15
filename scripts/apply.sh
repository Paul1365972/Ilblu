#!/usr/bin/env bash

# Copied from https://github.com/PaperMC/Paper/blob/089d83568b6876cd01eacdbe49aba34e14336ccf/scripts/applyPatches.sh
# License from Paper applies to this file

(
set -euo pipefail
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
    $gitcmd branch -f upstream "$branch"

    cd "$basedir/"
    if [ ! -d  "$basedir/$target" ]; then
        mkdir "$basedir/$target"
        cd "$basedir/$target/"
        $gitcmd init
        if [ -n "${5:-}" ]; then
            $gitcmd remote add origin "$5"
        fi
        cd "$basedir/"
    fi
    cd "$basedir/$target/"

    echo "Resetting $target to $what..."
    $gitcmd remote rm upstream 2>/dev/null || true
    $gitcmd remote add -f upstream "$basedir/$what"
    $gitcmd checkout -B master upstream/upstream 2>&1

    echo "  Applying patches to $target..."
    $gitcmd am --abort 2>/dev/null || true
    find "$basedir/patches/$patch_folder/"*.patch -print0 | xargs -0 $applycmd
    echo "  Patches applied cleanly to $target"
}

"$basedir/scripts/importmcdev.sh" "$basedir"

(
    applyPatch Paper/Paper-API ${FORK_NAME}-API HEAD api &&
    applyPatch Paper/Paper-Server ${FORK_NAME}-Server HEAD server

    # if we have previously created mcdev, update it
    if [ -d "$basedir/mc-dev" ]; then
        "$basedir/scripts/generatemcdevsrc.sh" "$basedir"
    fi
    echo "Patching finished"
)
)
