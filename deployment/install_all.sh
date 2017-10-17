#!/bin/bash
PLATFORM=$1

if ./install_jq.sh $PLATFORM && ./install_worker.sh $PLATFORM && ./install_cli_client.sh $PLATFORM
then
    echo "Installation complete!"
else
    echo "Installation failed"
fi