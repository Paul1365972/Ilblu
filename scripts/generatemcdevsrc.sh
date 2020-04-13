#!/usr/bin/env bash

# Copied from https://github.com/PaperMC/Paper/blob/089d83568b6876cd01eacdbe49aba34e14336ccf/scripts/makemcdevsrc.sh
# License from Paper applies to this file

(
set -e
basedir="$(cd "$1" && pwd -P)"
parentVer="$2"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false"

echo "Generating mc-dev source..."

cd "$basedir/"
minecraftversion=$(cat "$basedir/$WORK_PATH/BuildData/info.json"  | grep minecraftVersion | cut -d '"' -f 4)
srcnms="$basedir/$WORK_PATH/Minecraft/$minecraftversion/spigot/net/minecraft/server"
forknms="$basedir/$FORK_NAME-Server/src/main/java/net/minecraft/server"
mcdevnms="$basedir/mc-dev/src/net/minecraft/server"

# Reset mc-dev nms dir
rm -rf "$mcdevnms"
mkdir -p "$mcdevnms"

if [ ! -d "$basedir/mc-dev/.git" ]; then
	$gitcmd init
fi

# Copy nms from original minecraft to nms
find "$srcnms" -name "*.java" -exec cp "{}" "$mcdevnms" \;

# Remove all nms files already in paper
for file in "$mcdevnms/"*
do
    # Get basename
    file=${file##*/}
    # test if in fork folder - already imported
    if [ -f "$forknms/$file" ]; then
        # remove from mcdevnms folder
        rm -f "$mcdevnms/$file"
    fi
done

echo "Built mc-dev to be included in your project for src access";

cd "$basedir/mc-dev/"
$gitcmd add -all
$gitcmd commit --allow-empty -m "mc-dev"
$gitcmd tag -a "$parentVer" -m "$parentVer" 2>/dev/null
) || exit 1
