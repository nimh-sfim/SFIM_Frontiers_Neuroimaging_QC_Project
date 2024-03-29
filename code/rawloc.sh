#!/bin/bash

# Script to get specific raw files loaded
# Pass subject and filetype


subj=$1
ftype=$2
valid_ftypes="Valid ftypes are 'T1w', 'epi'"

subjloc=$($QC_CODE_ROOT/subj2loc.sh $subj)

# Need to get more stuff for rest sets, which have longer names
if [[ $((10#$subj)) -ge 101 ]]
then
    anat_addendum="_ses-01_run-01"
    func_addendum="_ses-01_task-rest_run-01"

else
    anat_addendum=""
    func_addendum="_task-pamenc"

fi

if [[ $ftype = "T1w" ]]
then
    sid=$(printf "%3.3d" $subj)
    f=$subjloc/anat/sub-${sid}${anat_addendum}_T1w.nii.gz

elif [[ $ftype = "epi" ]]
then
    sid=$(printf "%3.3d" $subj)
    f=$subjloc/func/sub-${sid}${func_addendum}_bold.nii.gz

else
    echo "$ftype is not a valid ftype"
    echo $valid_ftypes
    exit 1

fi


if [[ ! -f $f ]]
then
    echo "File $f does not exist but is expected"
    exit 1
fi

echo $f
