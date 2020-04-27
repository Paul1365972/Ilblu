#!/usr/bin/env bash

# Import Config from gradle.properties
while IFS="=" read key value; do
    key=$(echo $key | tr .-/ _)
    value=$(echo $value | tr -d "\r")
    if [ -n "$key" ] && [[ "$key" != "#"* ]]; then
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

function containsElement {
    local e
    for e in "${@:2}"; do
        [[ "$e" == "$1" ]] && return 0;
    done
    return 1
}
