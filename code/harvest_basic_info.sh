#!/bin/bash

# Harvests basic info for all task and rest data sets

if [[ ! $QC_CODE_ROOT ]]
then
    echo "Cannot find QC_CODE_ROOT"
    echo "Please set manually or source an environment variable script."
    exit 1
fi

if [[ ! $QC_META_ROOT ]]
then
    echo "Cannot find QC_META_ROOT"
    echo "Please set manually or source an environment variable script."
    exit 1
fi

mkdir -p $QC_META_ROOT

columns="subject,ni,nj,nk,nt,dx,dy,dz,tr,space,obliquity"

task_anat_csv="${QC_META_ROOT}/task_anat_info.csv"
task_func_csv="${QC_META_ROOT}/task_func_info.csv"
rest_anat_csv="${QC_META_ROOT}/rest_anat_info.csv"
rest_func_csv="${QC_META_ROOT}/rest_func_info.csv"
echo $columns > $task_anat_csv
echo $columns > $task_func_csv
echo $columns > $rest_anat_csv
echo $columns > $rest_func_csv

# First, we do anatomicals

for i in {1..30}
do
    sid=$(printf "%3.3d" $i)
    target=$(${QC_CODE_ROOT}/rawloc.sh $i T1w)
    if [[ $? != 0 ]]
    then
        echo "See error above; locator failed."
        exit 1
    fi
    info=$(${QC_CODE_ROOT}/basic_info.sh $target)
    line=$(printf "%s,%s\n" "sub-${sid}" $(echo $info | sed -r "s/[[:space:]]+/,/g"))
    echo $line >> $task_anat_csv
done

for i in {101..120}
do
    sid=$(printf "%3.3d" $i)
    target=$($QC_CODE_ROOT/rawloc.sh $i T1w)
    if [[ $? != 0 ]]
    then
        echo "See error above; locator failed."
        exit 1
    fi
    info=$(${QC_CODE_ROOT}/basic_info.sh $target)
    line=$(printf "%s,%s\n" "sub-${sid}" $(echo $info | sed -r "s/[[:space:]]+/,/g"))
    echo $line >> $rest_anat_csv
done


# Now, functionals

for i in {1..30}
do
    sid=$(printf "%3.3d" $i)
    target=$(${QC_CODE_ROOT}/rawloc.sh $i epi)
    if [[ $? != 0 ]]
    then
        echo "See error above; locator failed."
        exit 1
    fi
    info=$($QC_CODE_ROOT/basic_info.sh $target)
    line=$(printf "%s,%s\n" "sub-${sid}" $(echo $info | sed -r "s/[[:space:]]+/,/g"))
    echo $line >> $task_func_csv
done

for i in {101..120}
do
    sid=$(printf "%3.3d" $i)
    target=$(${QC_CODE_ROOT}/rawloc.sh $i epi)
    if [[ $? != 0 ]]
    then
        echo "See error above; locator failed."
        exit 1
    fi
    info=$(${QC_CODE_ROOT}/basic_info.sh $target)
    line=$(printf "%s,%s\n" "sub-${sid}" $(echo $info | sed -r "s/[[:space:]]+/,/g"))
    echo $line >> $rest_func_csv
done

