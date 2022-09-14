#!/bin/bash

sswarper_loc=$(which @SSwarper)

if [[ $? != 0 ]]
then
    echo "SUMA not found, is AFNI installed?"
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

sublabel="sub-${sid}"
suma_sub="${QC_FS_ROOT}/${sublabel}/surf/SUMA/"

surf_in="${suma_sub}/brain.finalsurfs.nii.gz"
ss_dir="${QC_WARPER_ROOT}/${sublabel}"
surf_brikhead="${ss_dir}/${sublabel}_Anat+orig"

mkdir -p $ss_dir

# First, we 3dcopy

3dcopy \
    $surf_in \
    $surf_brikhead

if [[ $? != 0 ]]
then
    echo "Unsure what happened; open an issue with text above..."
    echo "https://github.com/nimh-sfim/SFIM_Frontiers_Neuroimaging_QC_Project/issues"
    exit 1
fi

@SSwarper \
    -init_skullstr_off \
    -input $surf_brikhead \
    -base MNI152_2009_template_SSW.nii.gz \
    -subid $sublabel \
    -odir $ss_dir \
    -warpscale 0.5 \

if [[ $? != 0 ]]
then
    echo "Unsure what happened; open an issue with text above..."
    echo "https://github.com/nimh-sfim/SFIM_Frontiers_Neuroimaging_QC_Project/issues"
    exit 1
fi
