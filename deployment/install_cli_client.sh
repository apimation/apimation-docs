#!/bin/bash
TESTWORKERFILENAME=apimation
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

if [ ! -d apimation-client ]
then
    mkdir apimation-client
fi

RELEASEBINURL=`curl -s -L https://api.github.com/repos/dlocmelis/apimation-cli-client/releases/latest | jq1.5/jq '.assets[] | select(.name | contains("'$PLATFORM'"))' | jq1.5/jq '.browser_download_url'`
RELEASEBINURL=`echo $RELEASEBINURL | sed -e 's/"//g'`
curl -L $RELEASEBINURL -o apimation-client/$TESTWORKERFILENAME

chmod +x apimation-client/$TESTWORKERFILENAME
final="apimation client installed with version: "`apimation-client/$TESTWORKERFILENAME -version`
echo $final