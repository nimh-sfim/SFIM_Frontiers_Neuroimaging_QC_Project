#!/bin/bash

# Translate "task" or "rest" to the correct directory in this environment
# Usage: pass "task" or "rest" to this script to get back a directory

subj=$1
valid_ids="Valid task IDs range [001-030], valid rest IDs range [101-120]."

if [[ ! $subj ]]
then
    echo "You must supply a valid subject ID."
    echo $valid_ids
    exit 1
fi
if [[ $subj -ge 1 && $subj -le 30 ]]
then
    subj=$(printf "%3.3d" $subj)
    # Valid task
    loc=$QC_DATA_ROOT/raw/fmri-open-qc-task/sub-$subj

elif [[ $subj -ge 101 && $subj -le 120 ]]
then
    # Valid rest
    loc=$QC_DATA_ROOT/raw/fmri-open-qc-rest/sub-$subj/ses-01

else
    echo "Invalid ID supplied (${subj})."
    echo $valid_ids
    exit 1

fi

if [[ ! -d $loc ]]
then
    echo "Expected location $loc does not exist"
    exit 1
fi

echo $loc
