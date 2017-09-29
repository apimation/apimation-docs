#!/bin/bash
HOST_URL=$1

if [ -z $HOST_URL ]
then
    echo "Please specify host url as argument, can't be empty"
    exit 1
fi

sed -i.bak s~HOST_URL~$HOST_URL~g Environments/Staging.yaml

if [ $? ]
then
    echo "Staging environment looks like this now:"
    cat Environments/Staging.yaml
else
    echo "sed command failure"
    exit 1
fi