#!/bin/bash

if [[ ! $QC_CODE_ROOT ]]
then
    echo "QC_CODE_ROOT not set."
    echo "Please set it manually or source an environment template."
    exit 1
fi

$QC_CODE_ROOT/check_env.sh

if [[ $? != 0 ]]
then
    echo "Environment not set up correctly; see above."
    exit 1
fi

sid=$1
SUB_LABEL=$(printf sub-%3.3d $sid)
SUB_EPI=$("${QC_CODE_ROOT}/rawloc.sh" $sid epi)
TSV_BASENAME="simple_${SUB_LABEL}_task-pamenc_events.tsv"
SUB_TSV="${QC_SIMPLIFIED_TIMING}/${SUB_LABEL}/func/${TSV_BASENAME}"
SUB_TIMINGS="${QC_TIMING_ROOT}/${SUB_LABEL}"
mkdir -p $SUB_TIMINGS
SUB_PREFIX="${SUB_TIMINGS}/${SUB_LABEL}."

# Use timing_tool to convert tsv to 1D
timing_tool.py \
    -multi_timing_ncol_tsv $SUB_TSV \
    -write_as_married \
    -write_multi_timing $SUB_PREFIX

# Perform command line string manipulation
# control=$(cat $SUB_TSV | tail -n +2 | grep CONTROL | awk '{print  $1 ":"  $2}' | tr '\n' ' ' | sed 's/ $/\n/g')
# echo $control > $SUB_CONTROL
# task=$(cat $SUB_TSV | tail -n +2 | grep TASK | awk '{print  $1 ":"  $2}' | tr '\n' ' ' | sed 's/ $/\n/g')
# echo $task > $SUB_TASK

echo $SUB_TIMINGS
