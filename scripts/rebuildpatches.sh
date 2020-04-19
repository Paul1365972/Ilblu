#!/usr/bin/env bash

# Copied from https://github.com/PaperMC/Paper/blob/089d83568b6876cd01eacdbe49aba34e14336ccf/scripts/rebuildPatches.sh
# License from Paper applies to this file

(
set -euo pipefail
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false -c core.safecrlf=false"

echo "Rebuilding patch files from current fork state..."

function savePatches {
    target=$1
    patch_folder=$2
    from=$3
    to=$4

    cd "$basedir/$target/"
    mkdir -p "$basedir/$patch_folder"
    find "$basedir/$patch_folder" -name "*.patch" -type f -delete

    $gitcmd format-patch --no-signature --zero-commit --full-index --no-stat -N -o "$basedir/$patch_folder" "$from...$to"
    cd "$basedir/"
    $gitcmd add -A "$basedir/$patch_folder"
    echo "  Patches saved for $target to $patch_folder"
}

function save() {
    target=$1
    patches_folder=$2
    type=$3
    echo "Formatting patches for $target..."

    if [ -d "$basedir/$target/.git/rebase-apply" ]; then
        # in middle of a rebase, be smarter
        echo "REBASE DETECTED - PARTIAL SAVE"
        last=$(cat "$basedir/$target/.git/rebase-apply/last")
        next=$(cat "$basedir/$target/.git/rebase-apply/next")
        orderedfiles=$(find "$basedir/$target" -name "*.patch" | sort)
        for i in $(seq -f "%04g" 1 1 $last)
        do
            if [ $i -lt $next ]; then
                rm $(echo "$orderedfiles{@}" | sed -n "${i}p")
            fi
        done
    fi

    cd "$basedir/$target"
    from="upstream/upstream"
    for to in $(git tag --sort refname); do
        echo "Formatting from $from to $to"
        savePatches "$target" "$patches_folder/$(cut -d "-" -f2- <<< "$to")/$type" "$from" "$to"
        from="$to"
    done
}

save "${FORK_NAME}-API" patches api
save "${FORK_NAME}-Server" patches server

echo "Rebuild complete"
)
