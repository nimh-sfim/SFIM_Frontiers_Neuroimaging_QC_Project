#!/bin/bash

# Add slice timing information to epi files

abids_loc=$(which abids_tool.py)

if [[ $abids_loc =~ "not found" ]]
then
    echo "Cannot find abids_tool.py on path."
    echo "Is AFNI properly installed?"
    exit 1
fi

# for i in {1..30}
# do
#     epi=$($QC_CODE_ROOT/rawloc.sh $i epi)
#     abids_tool.py \
#         -input $epi \
#         -add_slice_times
#     if [[ ! $? ]]
#     then
#         echo "Encountered error; exiting..."
#         exit 1
#     fi
# done

for i in {101..120}
do
    sid=$(printf "%3.3d" $i)
    epi=$($QC_CODE_ROOT/rawloc.sh $sid epi)
    abids_tool.py \
        -input $epi \
        -add_slice_times
    if [[ ! $? ]]
    then
        echo "Encountered error; exiting..."
        exit 1
    fi

done
