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

function setUpstream() {
    source=$1
    target=$2

    cd "$basedir/$source/"
    $gitcmd fetch --all
    $gitcmd branch -f upstream

    cd "$basedir/$target/"
    echo "Resetting $target to $source..."
    $gitcmd remote rm upstream 2>/dev/null || true
    $gitcmd remote add -f upstream "$basedir/$source"
    $gitcmd checkout -B master upstream/upstream 2>&1
}

function applyPatch {
    source=$1
    target=$2
    patch_folder=$3

    echo "    Applying patches from $patch_folder..."

    cd "$basedir/$target/"
    $gitcmd am --abort 2>/dev/null || true
    find "$basedir/patches/$patch_folder/"*.patch -print0 | xargs -0 $applycmd
}

function apply() {
    source=$1
    target=$2
    type=$3

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

    echo "  Applying patches to $target..."

    while IFS='' read -r folder; do
        folder=$(echo -e "$folder" | sed -e 's/[\r\n]//g')
        if [ -n "$folder" ] && [ -d "$basedir/patches/$folder" ]; then
            if [ "${folder,,}" = "${FORK_NAME,,}" ]; then
                setUpstream "$source" "$target"
            fi
            applyPatch "$source" "$target" "$folder/$type"
        fi
    done < "$basedir/patches/apply"
    echo "  Patches applied cleanly to $target"
}

"$basedir/scripts/importmcdev.sh" "$basedir"

(
    apply Paper/Paper-API ${FORK_NAME}-API api &&
    apply Paper/Paper-Server ${FORK_NAME}-Server server

    # if we have previously created mcdev, update it
    if [ -d "$basedir/mc-dev" ]; then
        "$basedir/scripts/generatemcdevsrc.sh" "$basedir"
    fi
    echo "Patching finished"
)
)
