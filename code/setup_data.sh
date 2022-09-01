#!/bin/bash

# Add slice timing information to epi files

osf_loc=$(which osf)

if [[ $osf_loc =~ "not found" ]]
then
    echo "Cannot find osf client on path."
    echo "Is it properly installed?"
    exit 1
fi

orig_dir=$(pwd)
osf -p qaesm clone $QC_DATA_ROOT
cd $QC_DATA_ROOT/osfstorage
tar -xf fmri-open-qc-rest01.tar.gz
tar -xf fmri-open-qc-task.tar.gz
tar -xf simplified_task_fmri_timing.tgz
rm *.tar.gz
rm *.tgz
mkdir ../../raw
mv fmri-open-qc-rest ../../raw/
mv fmri-open-qc-task ../../raw/
mv simplified_task_fmri_timing ../../raw/
cd $orig_dir
