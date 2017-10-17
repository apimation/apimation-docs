#!/bin/bash
TESTWORKERFILENAME=testworker
PLATFORM=$1

if [ -z $PLATFORM ]
then
    echo "Please specify platform: [linux, macOS]"
    exit 1
elif [ ! $PLATFORM = linux ] && [ ! $PLATFORM = macOS ]
then
    echo "Please specify correct platform: [linux, macOS], you spefified: $PLATFORM"
    exit 1
fi

if [ ! -d testEngine ]
then
    mkdir testEngine
fi

RELEASEBINURL=`curl -s -L https://api.github.com/repos/dlocmelis/apimation-test-worker/releases/latest | jq1.5/jq '.assets[] | select(.name | contains("'$PLATFORM'"))' | jq1.5/jq '.browser_download_url'`
RELEASEBINURL=`echo $RELEASEBINURL | sed -e 's/"//g'`
curl -L $RELEASEBINURL -o testEngine/$TESTWORKERFILENAME

chmod +x testEngine/$TESTWORKERFILENAME
nohup testEngine/$TESTWORKERFILENAME -configPath config/worker/main.yaml &
echo $! > testEngine/testEngineWorker.pid
echo testEngineWorker downloaded and launched with `cat testEngine/testEngineWorker.pid` process ID