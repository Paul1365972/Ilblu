#!/usr/bin/env bash

# Import Config from gradle.properties
while IFS="=" read key value
  do
    key=$(echo $key | tr .-/ _)
    value=$(echo $value | tr -d "\r")
    if [ -n "$key" ] && [ "$key" != \#* ]; then
        declare "$key=$value"
    fi
  done < "$basedir/gradle.properties"

function bashColor {
if [ $2 ]; then
    echo -e "\e[$1;$2m"
else
    echo -e "\e[$1m"
fi
}
function bashColorReset {
    echo -e "\e[m"
}

function pushRepo {
    if [ "$(git config minecraft.push-${FORK_NAME})" == "1" ]; then
    echo "Pushing - $1 ($3) to $2"
    (
        cd "$1"
        git remote rm emc-push > /dev/null 2>&1
        git remote add emc-push $2 >/dev/null 2>&1
        git push emc-push $3 -f
    )
    fi
}

function containsElement {
    local e
    for e in "${@:2}"; do
        [[ "$e" == "$1" ]] && return 0;
    done
    return 1
}
