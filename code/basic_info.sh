#!/bin/bash

info_loc=$(which 3dinfo)
target=$1

# Pass in the desired dataset to get basic info for

if [[ $info_loc =~ "not found" ]]
then
    echo "Cannot find 3dinfo; is AFNI installed?"
    exit 1
fi

3dinfo \
    -n4 \
    -d3 \
    -tr \
    -space \
    -obliquity \
    $target
