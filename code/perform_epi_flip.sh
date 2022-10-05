#!/bin/bash

lr_loc=$(which 3dLRflip)

if [[ $? != 0 ]]
then
    echo "Cannot find afni_proc.py; is it installed?"
    exit 1
fi

if [[ ! $QC_FS_ROOT ]]
then
    echo "QC_FS_ROOT is not set."
    echo "Please set this manually or source a setup file."
    exit 1
fi

sid=$1

if [[ ! $sid ]]
then
    echo "You must pass a subject number."
    exit 1
fi

SUB_LABEL=$(printf "sub-%3.3d" $sid)
SUB_SUMA="${QC_FS_ROOT}/${SUB_LABEL}/surf/SUMA"
SUB_WARPER="${QC_WARPER_ROOT}/${SUB_LABEL}"

ANAT_SS="${SUB_WARPER}/anatSS.${SUB_LABEL}.nii"
ANAT_SKULL="${SUB_WARPER}/anatUAC.${SUB_LABEL}.nii"
AASEG="${SUB_SUMA}/aparc.a2009s+aseg.nii.gz"
AESEG=$AASEG
EPI=$($QC_CODE_ROOT/rawloc.sh $sid epi)
EPI_FLIPPED=$($QC_CODE_ROOT/rawloc.sh $sid epi | sed "s/_bold/_bold_flipped/g")
WARP_QQ="${SUB_WARPER}/anatQQ.${SUB_LABEL}.nii"
WARP_AFF="${SUB_WARPER}/anatQQ.${SUB_LABEL}.aff12.1D"
WARP_WARP="${SUB_WARPER}/anatQQ.${SUB_LABEL}_WARP.nii"

AP_OUT="${QC_AP_ROOT}/${SUB_LABEL}_flipped"

# Flip an EPI
3dLRflip \
    -prefix $EPI_FLIPPED \
    $EPI

# Re-run afni_proc for flipped epi
afni_proc.py \
    -subj_id ${SUB_LABEL} \
    -blocks despike tshift align tlrc volreg blur mask scale regress \
    -radial_correlate_blocks volreg \
    -copy_anat $ANAT_SS \
    -anat_has_skull no \
    -anat_follower anat_w_skull anat $ANAT_SKULL \
    -anat_follower_ROI aaseg anat $AASEG \
    -anat_follower_ROI aeseg epi $AESEG \
    -dsets $EPI_FLIPPED \
    -align_opts_aea -cost lpc+ZZ -giant_move -check_flip \
    -tlrc_base MNI152_2009_template_SSW.nii.gz \
    -tlrc_NL_warp \
    -tlrc_NL_warped_dsets \
        $WARP_QQ \
        $WARP_AFF \
        $WARP_WARP \
    -volreg_align_to first \
    -volreg_align_e2a \
    -volreg_tlrc_warp \
    -volreg_warp_dxyz 3 \
    -blur_size 6.0 \
    -mask_epi_anat yes \
    -regress_opts_3dD -jobs $QC_CPUS \
    -regress_make_corr_vols aeseg \
    -regress_anaticor_fast \
    -regress_censor_motion 0.25 \
    -regress_censor_outliers 0.05 \
    -regress_apply_mot_types demean deriv \
    -regress_est_blur_epits \
    -regress_est_blur_errts \
    -regress_bandpass 0.01 0.1 \
    -regress_polort 5 \
    -regress_run_clustsim no \
    -html_review_style pythonic \
    -out_dir $AP_OUT \
    -volreg_compute_tsnr yes \
    -regress_compute_tsnr yes \
    -scr_overwrite \
    -execute
