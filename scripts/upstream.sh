#!/usr/bin/env bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

git submodule update --init --recursive

# TODO remove
#cd "$basedir/ConcurrentUtil"
#mvn clean install
#cd ../

if [[ "$1" == up* ]]; then
    (
        cd "$basedir/Paper/"
        git fetch && git reset --hard origin/master
        cd ../
        git add Paper
    )
fi

cd "$basedir/Paper/"
paperVer=$(git rev-parse --short HEAD)

./paper patch

cd "Paper-Server"
mcVer=$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=minecraft_version -q -DforceStdout)

basedir
. "$basedir"/scripts/importmcdev.sh

minecraftversion=$(cat "$basedir"/Paper/work/BuildData/info.json | grep minecraftVersion | cut -d '"' -f 4)
version=$(echo -e "Paper: $paperVer\nmc-dev:$importedmcdev")
tag="${minecraftversion}-${mcVer}-$(echo -e $version | sha1sum | awk '{print $1}')"
# echo "$tag" > "$basedir"/current-paper
# Pass via argument, current-paper not needed anymore
"$basedir"/scripts/generatesources.sh "$tag"

cd Paper/

function tag {
(
    cd $1
    echo -e "$(date)\n\n$version" | git tag -a "$tag" -F - 2>/dev/null
)
}
echo "Tagging as $tag"
echo -e "$version"

tag Paper-API
tag Paper-Server

pushRepo Paper-API $PAPER_API_REPO $tag
pushRepo Paper-Server $PAPER_SERVER_REPO $tag
