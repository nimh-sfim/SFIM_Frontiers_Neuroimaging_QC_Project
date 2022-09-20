#!/bin/bash

# Template for setting up QC project environment

export QC_DATA_ROOT=/data/tevesjb/Frontiers_QC_2022
export QC_CODE_ROOT=/data/tevesjb/repositories/SFIM_Frontiers_Neuroimaging_QC_Project/code
export QC_FS_ROOT=/data/tevesjb/Frontiers_QC_2022/freesurfer
export SUBJECTS_DIR=$QC_FS_ROOT
export QC_CPUS=8
export QC_META_ROOT=/data/tevesjb/Frontiers_QC_2022/meta
export OMP_NUM_THREADS=8
export MNI_TEMPLATE="${QC_CODE_ROOT}/mni_icbm152_t1_tal_nlin_asym_09c.nii"
export QC_WARPER_ROOT=/data/tevesjb/Frontiers_QC_2022/sswarper
export QC_AP_ROOT=/data/tevesjb/Frontiers_QC_2022/ap_results
