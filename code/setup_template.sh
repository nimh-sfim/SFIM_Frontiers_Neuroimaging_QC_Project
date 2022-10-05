#!/bin/bash

# Template for setting up QC project environment

export QC_DATA_ROOT=/data/tevesjb/Frontiers_QC_2022
export QC_CODE_ROOT=/data/tevesjb/repositories/SFIM_Frontiers_Neuroimaging_QC_Project/code
export QC_FS_ROOT="${QC_DATA_ROOT}/freesurfer"
export SUBJECTS_DIR=$QC_FS_ROOT
export QC_CPUS=8
export QC_META_ROOT="${QC_DATA_ROOT}/meta"
export OMP_NUM_THREADS=8
export QC_WARPER_ROOT="${QC_DATA_ROOT}/sswarper"
export QC_AP_ROOT="${QC_DATA_ROOT}/ap_results"
export QC_SIMPLIFIED_TIMING="${QC_DATA_ROOT}/raw/simplified_task_fmri_timing"
export QC_TIMING_ROOT="${QC_DATA_ROOT}/timing_files"
