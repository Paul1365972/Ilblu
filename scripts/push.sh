#!/usr/bin/env bash

# TODO Think about this more before commiting
exit 0

minecraftversion=$(cat $basedir/Paper/work/BuildData/info.json | grep minecraftVersion | cut -d '"' -f 4)

cd "$basedir/"
pushRepo ${FORK_NAME}-API $API_REPO master:$minecraftversion
pushRepo ${FORK_NAME}-Server $SERVER_REPO master:$minecraftversion
