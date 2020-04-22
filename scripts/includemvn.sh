#!/usr/bin/env bash

cd "$basedir/"
echo "Including maven..."

if ! mvn -v 2> /dev/null; then
    echo "mvn missing"
    if [ ! -d "maven" ]; then
        echo "Downloading maven"
        curl -s http://apache.mirror.iphh.net/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar -xzf -
        mv apache-maven-* maven
    fi
    export PATH="$PATH:$basedir/maven/bin"
    echo "Exported mvn: $basedir/maven/bin"
fi
