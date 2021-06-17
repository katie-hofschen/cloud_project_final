#!/usr/bin/env bash

./fly -t cloud set-pipeline -c pipeline.yml -p create-resources -l pipeline-vars.yml
./fly -t cloud unpause-pipeline -p create-resources
./fly -t cloud trigger-job -j create-resources/create-resources

#fly -t cloud hijack -c create-resources/git