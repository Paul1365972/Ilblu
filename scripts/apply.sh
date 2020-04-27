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
    source=$1
    target=$2
    patches_folder=$3

    echo "    Applying patches from $patches_folder..."

    cd "$basedir/$target/"
    $gitcmd am --abort 2>/dev/null || true
    if [ -d "$basedir/patches/$patches_folder/" ]; then
        find "$basedir/patches/$patches_folder/" -name "*.patch" -print0 | sort -z | xargs -0 $applycmd
    fi
}

function apply() {
    source=$1
    target=$2
    type=$3

    cd "$basedir/$source/"
    $gitcmd fetch --all
    $gitcmd branch -f upstream

    cd "$basedir/"
    if [ ! -d  "$basedir/$target/" ]; then
        mkdir "$basedir/$target/"
        cd "$basedir/$target/"
        $gitcmd init
        if [ -n "${5:-}" ]; then
            $gitcmd remote add origin "$5"
        fi
        cd "$basedir/"
    fi

    cd "$basedir/$target/"
    echo "Resetting $target to $source..."
    $gitcmd tag | xargs $gitcmd tag -d
    $gitcmd remote rm upstream 2>/dev/null || true
    $gitcmd remote add -f upstream "$basedir/$source"
    $gitcmd checkout -B master upstream/upstream 2>&1

    echo "  Applying patches to $target..."

    index=1
    while IFS='' read -r folder; do
        folder=$(echo -e "$folder" | sed -e 's/[\r\n]//g')
        if [ -n "$folder" ] && [[ "$folder" != "#"* ]]; then
            if [ -d "$basedir/patches/$folder/" ]; then
                applyPatch "$source" "$target" "$folder/$type"
            fi
            cd "$basedir/$target"
            $gitcmd tag "$(printf "%02d" $index)-$folder"
            ((index++))
        fi
    done < "$basedir/patches/apply"
    echo "  Patches applied cleanly to $target"
}

"$basedir/scripts/importmcdev.sh" "$basedir"

(
    apply Paper/Paper-API ${FORK_NAME}-API api
    apply Paper/Paper-Server ${FORK_NAME}-Server server

    # if we have previously created mcdev, update it
    if [ -d "$basedir/mc-dev" ]; then
        "$basedir/scripts/generatemcdevsrc.sh" "$basedir"
    fi
    echo "Patching finished"
)
)
