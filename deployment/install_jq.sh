#!/bin/bash
TESTWORKERFILENAME=testworker
PLATFORM=$1

if [ -z $PLATFORM ]
then
    echo "Please specify platform: [linux, macOS]"
    exit 1
elif [ $PLATFORM = linux ]
then
    JQPLATFORM=jq-linux64
elif [ $PLATFORM = macOS ]
then
    JQPLATFORM=jq-osx-amd64
else
    echo "Please specify correct platform: [linux, macOS], you spefified: $PLATFORM"
    exit 1
fi

if [ ! -d jq1.5 ]
then
    mkdir jq1.5
fi

curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/$JQPLATFORM -o jq1.5/jq
chmod +x jq1.5/jq
echo JQ installed