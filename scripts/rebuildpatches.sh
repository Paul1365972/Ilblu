#!/usr/bin/env bash

# Copied from https://github.com/PaperMC/Paper/blob/089d83568b6876cd01eacdbe49aba34e14336ccf/scripts/rebuildPatches.sh
# License from Paper applies to this file

(
set -e
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false -c core.safecrlf=false"

echo "Rebuilding patch files from current fork state..."

function cleanupPatches {
    cd "$1"
    for patch in *.patch; do
        gitver=$(tail -n 2 "$patch" | grep -ve "^$" | tail -n 1)
        diffs=$($gitcmd diff --staged "$patch" | grep --color=none -E "^(\+|\-)" | grep --color=none -Ev "(From [a-f0-9]{32,}|\-\-\- a|\+\+\+ b|^.index)")

        testver=$(echo "$diffs" | tail -n 2 | grep --color=none -ve "^$" | tail -n 1 | grep --color=none "$gitver")
        if [ "x$testver" != "x" ]; then
            diffs=$(echo "$diffs" | sed 'N;$!P;$!D;$d')
        fi

        if [ "x$diffs" == "x" ] ; then
            $gitcmd reset HEAD "$patch" >/dev/null
            $gitcmd checkout -- "$patch" >/dev/null
        fi
    done
}

function savePatches {
    target=$1
    patchdir=$2
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
    else
        find "$basedir/$patchdir" -name "*.patch" -type f -delete
    fi

    cd "$basedir/$target/"

    $gitcmd format-patch --no-signature --zero-commit --full-index --no-stat -N -o "$basedir/$patchdir" upstream/upstream
    cd "$basedir/"
    $gitcmd add -A "$basedir/$patchdir"
    # Not needed because we do --no-signature
    # if [ "$nofilter" == "0" ]; then
    #     cleanupPatches "$basedir/${what_name}-Patches"
    # fi
    echo "  Patches saved for $target to $patchdir"
}

savePatches ${FORK_NAME}-API patches/api
savePatches ${FORK_NAME}-Server patches/server
) || exit 1
