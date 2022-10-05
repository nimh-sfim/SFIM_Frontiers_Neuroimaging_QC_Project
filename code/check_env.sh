#!/bin/zsh

# zsh script to check that necessary environment variables are set

# check for data root
if [[ ! -d $QC_DATA_ROOT ]]
then
    echo "QC_DATA_ROOT not set or not a valid directory"
    exit 1
fi

# check for code root
if [[ ! -d $QC_CODE_ROOT ]]
then
    echo "QC_CODE_ROOT not set or not a valid directory"
    exit 1
fi

# check for freesurfer
fs_loc=$(which recon-all)

if [[ $? != 0 ]]
then
    echo "freesurfer is not loaded."
    echo "Please ensure that it is installed correctly."
    exit 1
fi

af_loc=$(which 3dinfo)

if [[ $? != 0 ]]
then
    echo "AFNI is not loaded."
    echo "Please ensure that it is installed correctly."
    exit 1
fi
