#!/usr/bin/env bash

# Copied from https://github.com/PaperMC/Paper/blob/089d83568b6876cd01eacdbe49aba34e14336ccf/scripts/importmcdev.sh
# License from Paper applies to this file

(
set -e
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
nms="net/minecraft/server"
export MODLOG=""
gitcmd="git -c commit.gpgsign=false"

echo "Importing mc-dev files..."

workdir="$basedir/$WORK_PATH"
minecraftversion=$(cat "$workdir/BuildData/info.json" | grep minecraftVersion | cut -d '"' -f 4)
decompiledir="$workdir/Minecraft/$minecraftversion/spigot"

export importedmcdev=""
function import {
    export importedmcdev="$importedmcdev $1"
    file="$1.java"
    target="$basedir/Paper/Paper-Server/src/main/java/$nms/$file"
    base="$decompiledir/$nms/$file"

    if [[ ! -f "$target" ]]; then
        export MODLOG="$MODLOG  Imported $file from mc-dev\n";
        echo "$(bashColor 1 32) Copying $(bashColor 1 34)$base $(bashColor 1 32)to$(bashColor 1 34) $target $(bashColorReset)"
        cp "$base" "$target"
    else
        echo "$(bashColor 1 33) UN-NEEDED IMPORT STATEMENT:$(bashColor 1 34) $file $(bashColorReset)"
    fi
}

function importLibrary {
    group=$1
    lib=$2
    prefix=$3
    shift 3
    for file in "$@"; do
        file="$prefix/$file"
        target="$basedir/Paper/Paper-Server/src/main/java/$file"
        targetdir=$(dirname "$target")
        mkdir -p "${targetdir}"
        base="$workdir/Minecraft/$minecraftversion/libraries/${group}/${lib}/$file"
        if [ ! -f "$base" ]; then
            echo "Missing $base"
            exit 1
        fi
        export MODLOG="$MODLOG  Imported $file from $lib\n";
        sed 's/\r$//' "$base" > "$target" || exit 1
    done
}

(
    cd "$basedir/Paper/Paper-Server/"
    lastlog=$($gitcmd log -1 --oneline)
    if [[ "$lastlog" = *"$FORK_NAME-Extra mc-dev Imports"* ]]; then
        $gitcmd reset --hard HEAD^
    fi
)

files=$(cat "$basedir/patches/server/"* | grep "+++ b/src/main/java/net/minecraft/server/" | sort | uniq | sed 's/\+\+\+ b\/src\/main\/java\/net\/minecraft\/server\///g' | sed 's/.java//g')
# Maybe "create mode " is correct here, probably not though
nonnms=$(grep -R "new file mode" -B 1 "$basedir/patches/server/" | grep -v "new file mode" | grep -oE "net\/minecraft\/server\/.*.java" | grep -oE "[A-Za-z]+?.java$" --color=none | sed 's/.java//g')

for f in $files; do
    containsElement "$f" ${nonnms[@]}
    if [ "$?" == "1" ]; then
        if [ ! -f "$basedir/Paper/Paper-Server/src/main/java/net/minecraft/server/$f.java" ]; then
            if [ ! -f "$decompiledir/$nms/$f.java" ]; then
                echo "$(bashColor 1 31) ERROR!!! Missing NMS$(bashColor 1 34) $f $(bashColorReset)";
            else
                import $f
            fi
        fi
    fi
done

########################################################
########################################################
########################################################
#                   NMS IMPORTS
# Temporarily add new NMS dev imports here before you run paper patch
# but after you have paper rb'd your changes, remove the line from this file before committing.
#
# import FileName



########################################################
########################################################
########################################################
#              LIBRARY IMPORTS
# These must always be mapped manually, no automatic stuff
#
#             # group    # lib          # prefix               # many files

importLibrary com.mojang datafixerupper com/mojang/datafixers/util Either.java

################

# TODO figure out what and why this is here
(
    cd "$basedir/Paper/Paper-Server/"
    rm -rf nms-patches applyPatches.sh makePatches.sh
    $gitcmd add src -A
    echo -e "$FORK_NAME-Extra mc-dev Imports\n\n$MODLOG" | $gitcmd commit src -F -
)
# This last echo is needed so the script doesn exit 1 and crash
echo "Import mc-dev finished"
) || exit 1
