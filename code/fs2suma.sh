#!/bin/bash

makespec_loc=$(which @SUMA_Make_Spec_FS)

if [[ $? != 0 ]]
then
    echo "SUMA not found, is AFNI installed?"
    exit 1
fi

reconall_loc=$(which recon-all)

if [[ $? != 0 ]]
then
    echo "recon-all not found, is freesurfer installed and setup?"
    exit 1
fi

subject=$1

if [[ ! $subject ]]
then
    echo "You must provide a subject number."
    exit 1
fi

sid=$(printf "%3.3d" $subject)

if [[ ! $QC_CODE_ROOT ]]
then
    echo "QC_CODE_ROOT is not set."
    echo "Please set this manually or source a setup file."
    exit 1
fi

currdir=$(pwd)
sublabel="sub-${sid}"
fs_sub="${QC_FS_ROOT}/${sublabel}/surf"

cd $fs_sub

if [[ $? != 0 ]]
then
    echo "Cannot find subject surface. Did you run freesurfer?"
    exit 1
fi

@SUMA_Make_Spec_FS \
    -fs_setup \
    -NIFTI \
    -sid "sub-${sid}" \
    -fspath .

cd $currdir

if [[ $? != 0 ]]
then
    echo "Unsure what happened; open an issue with text above..."
    echo "https://github.com/nimh-sfim/SFIM_Frontiers_Neuroimaging_QC_Project/issues"
    exit 1
fi
