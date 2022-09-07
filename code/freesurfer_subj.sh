#!/bin/bash

# Run freesurfer for one subject

reconloc=$(which recon-all)

if [[ $reconloc =~ "not found" ]] || [[ $reconloc =~ "no recon-all" ]]
then
    echo "Cannot find recon-all, is freesurfer loaded?"
    exit 1
fi

nuloc=$(which nu_correct)
if [[ $reconloc =~ "not found" ]] || [[ $reconloc =~ "no recon-all" ]] || $!
then
    # We need to find and source SetUpFreeSurfer.sh
    echo "Calling SetUpFreeSurfer.sh; missing some fs utils..."
    fsbase=$(dirname $(dirname $reconloc))
    setup="${fsbase}/SetUpFreeSurfer.sh"
    source $setup
    echo "Done setting up freesurfer"
fi

if [[ ! $SUBJECTS_DIR ]]
then
    echo "Must set SUBJECTS_DIR environment variable."
    echo "Do so manually or run the environment setup script."
    exit 1
fi

if [[ ! $QC_CPUS ]]
then
    echo "Must set QC_CPUS environment variable."
    echo "Do so manually or run the environment setup script."
    exit 1
fi

subject=$1

if [[ ! $subject ]]
then
    echo "Must supply a subject number"
    exit 1
fi

sid=$(printf "%3.3d" $subject)

raw_loc=$($QC_CODE_ROOT/rawloc.sh $sid T1w)

recon-all \
    -subjid "sub-${sid}" \
    -i $raw_loc \
    -openmp $QC_CPUS \
    -all
