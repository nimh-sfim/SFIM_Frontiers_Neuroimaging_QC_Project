#!/bin/zsh

# Script to get the anatomical directory from a subject
subj=$1

subjloc=$($QC_CODE_ROOT/subj2loc.sh $subj)
anat=$subjloc/anat

echo $anat
