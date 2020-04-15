#!/usr/bin/env bash

(
set -euo pipefail
basedir="$(cd "$1" && pwd -P)"
source "$basedir/scripts/functions.sh"
gitcmd="git -c commit.gpgsign=false"

echo "Updating upstream..."

cd "$basedir/"
git submodule update --init --recursive

if [[ "${2:-}" == up* ]]; then
    (
        cd "$basedir/Paper/"
        git fetch && git reset --hard origin/master
        cd "$basedir/"
        git add Paper
    )
fi

cd "$basedir/Paper/"

echo "Patching parent"
./paper patch
parentVer=$($gitcmd rev-parse --short HEAD)

cd "$basedir/Paper/Paper-Server/"
mcVer=$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=minecraft_version -q -DforceStdout)

cd "$basedir/"
source "$basedir/scripts/importmcdev.sh"

minecraftversion=$(cat "$basedir/$WORK_PATH/BuildData/info.json" | grep minecraftVersion | cut -d '"' -f 4)
version=$(echo -e "Paper: $parentVer\nmc-dev:$importedmcdev")
tag="$minecraftversion-$mcVer-$(echo $version | sha1sum | awk '{print $1}')"
# echo "$tag" > "$basedir"/current-paper
# Pass via argument, current-paper not needed anymore
"$basedir/scripts/generatemcdevsrc.sh" "$basedir" "$tag"

cd "$basedir/Paper/"

function tag {
(
    cd "$1"
    echo "Tagging as $tag and version $version"
    # echo -e "$(date)\n\n$version" | git tag -a "$tag" -F - 2>/dev/null
    git tag -f -a "$tag" -m "$(date)" -m "" -m "$version"
)
}
echo "Tagging as $tag"
echo "Version:"
echo "$version"

tag Paper-API
tag Paper-Server

echo "Finished upstream"
)
