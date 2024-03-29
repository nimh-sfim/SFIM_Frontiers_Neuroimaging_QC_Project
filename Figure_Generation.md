# Notes on Figure Generation

Many of the figures are based images that were automatically created when
`afni_proc.py` was run for each subject. The followings desecriptions list
which images were used or what was done to go from the generated images
to the figures that are included in the manuscript.

## Figure 1

Generated by manually saving slices in the AFNI GUI.
`./ap_results_unifize/sub-017/pb00.sub-017.r01.tcat+orig.HEAD`
was used. The I,J,K coordinates for the crosshairs are (32,32,17).
The images are from volume indices: 20, 35, 42, and 54.

 The motion and outlier time course was automatically generated by
 `afni_proc.py` and included in the html report. That figure is stored as
 `./ap_results_unifize/sub-017/QC_sub-017/media/qc_09_mot_enormoutlr.jpg`

Note: For all jpg images in the media directory of the html report, there is
also a json file that lists the source volumes used to create the image.

## Figure 2

Generated by manually saving slices in the AFNI GUI.
`./ap_results_unifize/sub-029/pb00.sub-029.r01.tcat+orig.HEAD`
was used. The I,J,K coordinates for the crosshairs are (32,32,17).
The images are from volume indices: 155, 166, 167, and 173.

 The motion and outlier time course was automatically generated and included
 in the html report. That figure is stored as
 `./ap_results_unifize/sub-029/QC_sub-029/media/qc_09_mot_enormoutlr.jpg`

## Figure 3

Not automatically output by AFNI. The following steps were required to create it:

```bash
# From the directory: ./Frontiers_QC_2022/Figure8_Overlap_Maps  

#### 
# For the sub-001 to sub-030 Task dataset  
# Create a summed count of the number of subjects with a voxel within a mask 
3dMean -sum -prefix sub-0xx.mask.overlap.nii.gz \
  ../ap_results_unifize/sub-0??/mask_epi_anat.sub-0??+tlrc.HEAD

# We use using alpha thresholding to create a contour for N=30 (voxels with all sbj in mask)
#  but then voxels with lower voxels get more translucent.
#  P Taylor suggested addressing this issue by making a threshold volume where
#  N=30 is 1 and 29>=N>=1 is 0.97
#  Then the threshold volume is used for thresholding and there's almost no decrease
#  in translucency while the summation count volume is used for coloring
3dcalc -prefix sub-0xx.mask.threshold.nii.gz \
  -a sub-0xx.mask.overlap.nii.gz \
  -expr "step(a)*(1*equals(a,30)+0.97*not(equals(a,30)))"
3dTcat -prefix sub-0xx.maskthresh.nii.gz \
  sub-0xx.mask.overlap.nii.gz sub-0xx.mask.threshold.nii.gz

# For the sub-101 to sub-120 Rest dataset
3dMean -sum -prefix sub-1xx.mask.overlap.nii.gz \
  ../ap_results_masked_warper_rest/sub-1??/mask_epi_anat.sub-1??+tlrc.HEAD
3dcalc -prefix sub-1xx.mask.threshold.nii.gz \
  -a sub-1xx.mask.overlap.nii.gz \
  -expr "step(a)*(1*equals(a,20)+0.97*not(equals(a,20)))"
3dTcat -prefix sub-1xx.maskthresh.nii.gz \
  sub-1xx.mask.overlap.nii.gz sub-1xx.mask.threshold.nii.gz



# Locate the anatomical template to use as the image underlay.  
templ_path=`@FindAfniDsetPath MNI152_2009_template_SSW.nii.gz`
underlay_dset=${templ_path}/MNI152_2009_template_SSW.nii.gz

####
# Create the image for the Task data
# The underlay is the MNI anatomical alignment template
# The overlay is colored from 1-30
# The overlay is thresholded so that there can be a countour
# line around all N=30 voxels
olay_dset=sub-0xx.maskthresh.nii.gz
@chauffeur_afni        \
  -prefix Figure3_part_TaskData_OverlapMap \
  -pbar_saveim Figure3_part_TaskData_colorbar.jpg \
  -func_range 30 \
  -ulay ${underlay_dset} \
  -olay ${olay_dset} \
  -set_dicom_xyz 1 16 6 \
  -delta_slices 28 36 31 \
  -cbar Plasma \
  -pbar_posonly \
  -save_ftype SAVE_ALLJPEG \
  -ulay_range 0% 98% \
  -thr_olay 0.99 \
  -olay_alpha Linear \
  -olay_boxed Yes \
  -set_subbricks 0 0 1 \
  -opacity 5  \
  -save_ftype JPEG \
  -montx 5 -monty 1 \
  -montgap 0  \
  -montcolor 'black' \
  -set_xhairs OFF \
  -label_mode 1 -label_size 4 \
  -do_clean

#  -box_focus_slices AMASK_FOCUS_OLAY \


####
# Create the image for the Rest data
# The underlay is the MNI anatomical alignment template
# The overlay is colored from 1-20
# The overlay is thresholded so that there can be a countour
# line around all N=20 voxels
olay_dset=sub-1xx.maskthresh.nii.gz
@chauffeur_afni        \
  -prefix Figure3_part_RestData_OverlapMap \
  -pbar_saveim Figure3_part_RestData_colorbar.jpg \
  -func_range 20 \
  -ulay ${underlay_dset} \
  -olay ${olay_dset} \
  -set_dicom_xyz 1 16 6 \
  -delta_slices 28 36 31 \
  -cbar Plasma \
  -pbar_posonly \
  -save_ftype SAVE_ALLJPEG \
  -ulay_range 0% 98% \
  -thr_olay 0.99 \
  -olay_alpha Linear \
  -olay_boxed Yes \
  -set_subbricks 0 0 1 \
  -opacity 5  \
  -save_ftype JPEG \
  -montx 5 -monty 1 \
  -montgap 0  \
  -montcolor 'black' \
  -set_xhairs OFF \
  -label_mode 1 -label_size 4 \
  -do_clean 
  # -crop_axi_x 23 172 \
  # -crop_axi_y 17 203 \
  # -crop_sag_x 17 203 \
  # -crop_sag_y 17 192 \
  # -crop_cor_x 23 172 \
  # -crop_cor_y 17 192 \
 
```

This generates mosaics for each orientation plane.
These images were then processed in GIMP. The black background was filled with
a consistent shade of black and then “zealous crop” was used to
remove black space between, above, and below slices. This retained all data,
including any ghosting, while letting the brain slices be relatively large
within the same amount of space.

## Figure 4

Uses images that were automatically generated by AFNI's @SSwarper command.
In `ap_results_unifize/sub-001/QC_sub-001/media` and
`ap_results_unifize/sub-016/QC_sub-016/media` the following files
were used:
- Full F stat map for axial slices: `qc_06_vstat_Full_Fstat.axi.jpg`
- Full F stat map for sagittal slices: `qc_06_vstat_Full_Fstat.sag.jpg`
- F stat map colorbar: `qc_06_vstat_Full_Fstat.pbar.jpg`
    - The maximum and minimum values for the colorbar are in related json files and
  in the html report
- Correlation to white matter ROI for axial slices: `qc_15_regr_corr_errts.axi.jpg`
- Correlation to white matter ROI for sagittal slices: `qc_15_regr_corr_errts.sag.jpg`
- Corrlation to WM color bar `qc_15_regr_corr_errts.pbar.jpg`

All mosiac images were cropped in Adobe Illustrator to show a subset of slices.

## Figure 5

Code to generate visualizations for figure 5A.

```bash
cd ./ap_results_unifize/sub-018
# Calc Euclidian Norm of motion time series rather than deriv of motion timeseries
1d_tool.py -infile motion_demean.1D -collapse_cols euclidean_norm -write motion_demean_enorm.1D

# Generate the instacorr map for predefined seed coordinate
# The 'keypress w' option will save the time series for the seed voxel
portnum=`afni -available_npb_quiet`
sbjid=sub-018
dset_ulay=pb03.${sbjid}.r01.volreg+tlrc.HEAD
# coord="-7.5 76.5 -7.5"
coord1="-19.5 70.5 16.5"
thresh="0.001p"
afni -q  -no_detach                                                     \
    -npb ${portnum}                                                     \
     -com "SWITCH_UNDERLAY    ${dset_ulay}"                             \
     -com "INSTACORR INIT                                               \
                     DSET=${dset_ulay}                                    \
                     BLUR=0                                    \
                 AUTOMASK=yes                                \
                  DESPIKE=no                                 \
                 BANDPASS=0.01,1                                \
                   POLORT=3                                  \
                  SEEDRAD=0                                 \
                   METHOD=P"                                 \
     -com "INSTACORR SET      ${coord1} J"                               \
     -com "SET_THRESHNEW      ${thresh}"                                \
     -com "SET_PBAR_ALL       -99 0.6 Reds_and_Blues_Inv" \
     -com "SET_FUNC_RANGE     0.6"                                \
     -com "SET_XHAIRS         Single"                                \
     -com "SET_XHAIR_GAP      -1"                                \
     -com "OPEN_WINDOW sagittalimage  opacity=8"                       \
     -com "OPEN_WINDOW coronalimage  opacity=8"                       \
     -com "OPEN_WINDOW axialimage  opacity=8"                       \
     -com "OPEN_WINDOW axialgraph matrix=1 geom=1000x250 keypress=w" \
     -com "SAVE_PNG axialimage instacorr_${sbjid}_coord1_p001.ax.png blowup=3" \
     -com "SAVE_PNG sagittalimage instacorr_${sbjid}_coord1_p001.sag.png blowup=3" \
     -com "SAVE_PNG coronalimage instacorr_${sbjid}_coord1_p001.cor.png blowup=3" \
     -yesplugouts \
     $dset_ulay  &

    # Plot the seed time series along with the motion time series on a single axis
    1dplot -naked -aspect 4 -one -demean -norm1 -jpgs 2048 instacorr_${sbjid}_coord1_p001.axgraph.jpg 038_020_031.1D motion_demean_enorm.1D 
```

Code to generate visualizations for figure 5B. Saves the EPI,
Anatomical, and EPI with instacorr overlay for a single coordinate
with axial, sagittal, and coronal slices.

```bash
cd ./ap_results_unifize/sub-002

portnum=`afni -available_npb_quiet`
sbjid=sub-002
dset_ulay=pb00.${sbjid}.r01.tcat+orig.HEAD
coord1="-3.145 -36.019 -9.8"
thresh="0.001p"

afni -q  -no_detach                                                     \
    -npb ${portnum}                                                     \
    -com "SWITCH_UNDERLAY anatSS.${sbjid}_al_junk+orig.HEAD" \
     -com "OPEN_WINDOW sagittalimage  opacity=8"                       \
     -com "OPEN_WINDOW coronalimage  opacity=8"                       \
     -com "OPEN_WINDOW axialimage  opacity=8"                       \
     -com "SET_XHAIRS         Single"                                \
     -com "SET_XHAIR_GAP      -1"                                \
     -com "SET_DICOM_XYZ $coord1" \
     -com "SAVE_PNG axialimage anat_${sbjid}_coord1.ax.png blowup=3" \
     -com "SAVE_PNG sagittalimage anat_${sbjid}_coord1.sag.png blowup=3" \
     -com "SAVE_PNG coronalimage anat_${sbjid}_coord1.cor.png blowup=3" \
     -com "SWITCH_UNDERLAY    ${dset_ulay}"                             \
     -com "SET_DICOM_XYZ $coord1" \
     -com "SAVE_PNG axialimage epi_${sbjid}_coord1.ax.png blowup=5" \
     -com "SAVE_PNG sagittalimage epi_${sbjid}_coord1.sag.png blowup=5" \
     -com "SAVE_PNG coronalimage epi_${sbjid}_coord1.cor.png blowup=5" \
     -com "INSTACORR INIT                                               \
                     DSET=${dset_ulay}                                    \
                     BLUR=0                                    \
                 AUTOMASK=yes                                \
                  DESPIKE=no                                 \
                 BANDPASS=0.01,1                                \
                   POLORT=3                                  \
                  SEEDRAD=0                                 \
                   METHOD=P"                                 \
     -com "INSTACORR SET      ${coord1} J"                               \
     -com "SET_THRESHNEW      ${thresh}"                                \
     -com "SET_PBAR_ALL       -99 0.6 Reds_and_Blues_Inv" \
     -com "SET_FUNC_RANGE     0.6"                                \
     -com "SAVE_PNG axialimage instacorr_${sbjid}_coord1_p001.ax.png blowup=5" \
     -com "SAVE_PNG sagittalimage instacorr_${sbjid}_coord1_p001.sag.png blowup=5" \
     -com "SAVE_PNG coronalimage instacorr_${sbjid}_coord1_p001.cor.png blowup=5" \
     $dset_ulay anatSS.${sbjid}_al_junk+orig.HEAD &

```

## Figure 6

Uses images that were automatically generated by AFNI's @SSwarper command.
In `ap_results_unifize/sub-109/QC_sub-109/media`,
`ap_results_unifize/sub-102/QC_sub-102/media`, and
`ap_results_unifize/sub-114/QC_sub-114/media`
the following files were used:

- Correlations to the PCC: `qc_06_vstat_seed_lh-PCC.axi.jpg` with colorbar: `qc_06_vstat_seed_lh-PCC.pbar.jpg`
- Correlation to white matter `qc_13_regr_corr_errts.axi.jpg` with colorbar: `qc_13_regr_corr_errts.pbar.jpg`
- Local correlations `qc_16_radcor_rc_volreg_r01.axi.jpg` with colorbar: `qc_16_radcor_rc_volreg_r01.pbar.jpg`
- EPI variance line warnings `qc_21_warns_vlines_0.sag.jpg`

Mosaic images were cropped in Adobe Illustrator to present a subset of slices.
The maximum and minimum values for the colorbars are in related json files and
in the html report

## Figure 7

Uses images that were automatically generated as part of AFNI’s html report
with images for the presented subjects in:
`./ap_results_masked_warper_rest/sub-115/QC_sub-115/media` and
`./ap_results_masked_warper_rest/sub-116/QC_sub-116/media`

The unflipped axial and sagittal images are:
`/qc_20_warns_flip_0.axi.jpg` and `/qc_20_warns_flip_0.sag.jpg`

The flipped axial and sagittal images are:
`/qc_20_warns_flip_1.axi.jpg` and `/qc_20_warns_flip_1.sag.jpg`

All mosiac images were cropped in Adobe Illustrator to show a subset of slices.

Generating the cost function plot first used a script to pull the cost functions from each run

```bash
# Within each subject, the minimum cost value is stored in a file in the row beginning with 'flip_cost_orig'

# Get cost vals from task data
grep flip_cost_orig ap_results_unifize/sub-???/aea_checkflip_results.txt | awk '{print $3}' > ./cost_func_vals/task_data_correct_anats.txt

# Get cost vals from task data from the original submission when the wrong anatomicals were used
grep flip_cost_orig ap_results_unifize_WRONGANATOMICALS/sub-???/aea_checkflip_results.txt | awk '{print $3}' > ./cost_func_vals/task_data_wrong_anats.txt

# Get cost vals from rest data
grep flip_cost_orig ap_results_masked_warper_rest/sub-???/aea_checkflip_results.txt | awk '{print $3}' > ./cost_func_vals/rest_data.txt
```

Then use the outputted files to generate a plot in python

```python
from matplotlib import pyplot as plt
from matplotlib.lines import Line2D
import os
import numpy as np

os.chdir('/Volumes/NIMH_SFIM/handwerkerd/Frontiers_QC_2022/')
fnames = ['rest_data', 'task_data_correct_anats', 'task_data_wrong_anats']
flabels = ['Rest', 'Task Correct Anatomicals', 'Task Wrong Anatomicals']
wrong_task_anat_markers=['.','.','.','.','.','.','.','.','.','X',
                    'X','X','X','X','X','X','X','X','X','X',
                    'X','X','X','X','X','X','X','X','X','X']
LR_warning_rest_markers=['X','.','.','.','.','.','.','.','.','.',
                         '.','.','.','.','X','X','.','.','.','.']
costvals = [[],[],[]]
for idx, fname in enumerate(fnames):
    tmp_file = open(f'cost_func_vals/{fname}.txt', 'r')
    tmp_content = tmp_file.readlines()
    costvals[idx] = [float(f) for f in tmp_content]
    print(costvals[idx])

plt.clf()
fig = plt.figure(figsize=(15,4))
for midx in range(len(LR_warning_rest_markers)):
    plt.plot(costvals[0][midx], 2, marker=LR_warning_rest_markers[midx], markerfacecolor='blue', markeredgecolor='None', markersize=15, linestyle='None')

# plt.plot(costvals[0], 2*np.ones((len(costvals[0]),1)), marker='.', markerfacecolor='blue', markeredgecolor='None', markersize=15, linestyle='None')
plt.plot(costvals[1], 1.5*np.ones((len(costvals[1]),1)), marker='.', markerfacecolor='green', markeredgecolor='None', markersize=15, linestyle='None')
for midx in range(len(wrong_task_anat_markers)):
    plt.plot(costvals[2][midx], 1, marker=wrong_task_anat_markers[midx], markerfacecolor='red', markeredgecolor='None', markersize=15, linestyle='None')
legend_elements = [Line2D([0], [0], marker='.', markerfacecolor='blue', markeredgecolor='None', markersize=15, linestyle = 'None',label='Rest Data'),
                   Line2D([0], [0], marker='.', markerfacecolor='green', markeredgecolor='None', markersize=15, linestyle = 'None',label='Task Data, Correct Anatomicals'),
                   Line2D([0], [0], marker='.', markerfacecolor='red', markeredgecolor='None', markersize=15, linestyle = 'None',label='Task Data, Wrong Anatomicals'),
                   Line2D([0], [0], marker='.', markerfacecolor='gray', markeredgecolor='None', markersize=15, linestyle = 'None',label='Correct anatomicals'),
                   Line2D([0], [0], marker='X', markerfacecolor='gray', markeredgecolor='None', markersize=15, linestyle = 'None',label='Wrong anats or flip LR'),
]
plt.legend(handles=legend_elements, loc='lower left')
ax = plt.gca()
ax.get_yaxis().set_visible(False)
ax.set_xlabel('Alignment Cost Function Value')
plt.savefig('./cost_func_vals/Fig7_part_cost_functions.svg', dpi=600, pad_inches=0.5)
plt.savefig('./cost_func_vals/Fig7_part_cost_functions.eps', dpi=600, pad_inches=0.5)
plt.savefig('./cost_func_vals/Fig7_part_cost_functions.png', dpi=600, pad_inches=0.5)
```

## Figure X

This was a figure that was generated to try to visualize the differences between
using the correct and incorrect anatomicals for alignment. The differences were
subtle and this visualization did not add much to the manuscript beyond what was
in the text, but the code to regenerate this comparision might be useful.

```bash
# This is a directory where we copied the aligned anatomical
# and function from the correct processing stream and when
# the wrong anatomical was used. In this case, it was the
# EPI data from sub-021 and the anatomical from sub-017
# "wrong_" is prepended to the file names from the wrong
# alignment
cd ./Frontiers_QC_2022/Wrong_Right_AnatCompare/sub-021

@chauffeur_afni        \
  -prefix FigureX_part_anat_correct \
  -ulay  anat_final.sub-021+tlrc.HEAD \
  -set_dicom_xyz 22 28 44 \
  -save_ftype JPEG \
  -ulay_range 0% 98% \
  -set_subbricks 0 0 0 \
  -montcolor 'black' \
  -montx 1 -monty 1 \
  -set_xhairs OFF \
  -label_mode 0 \
  -do_clean  
  # -label_size 4 \

  @chauffeur_afni        \
  -prefix FigureX_part_anat_wrong \
  -ulay  wrong_anat_final.sub-021+tlrc.HEAD \
  -set_dicom_xyz 22 28 44 \
  -save_ftype JPEG \
  -ulay_range 0% 98% \
  -set_subbricks 0 0 0 \
  -montcolor 'black' \
  -montx 1 -monty 1 \
  -set_xhairs OFF \
  -label_mode 0 \
  -do_clean 


  @djunct_edgy_align_check                                                     \
    -olay              anat_final.sub-021+tlrc.HEAD \
    -ulay              final_epi_vr_base+tlrc.HEAD                                     \
    -use_olay_grid     wsinc5                                                \
    -ulay_range_am     "1%" "95%"                                            \
    -ulay_min_fac      0.2                                                   \
    -set_dicom_xyz 22 28 44 \
    -save_ftype JPEG \
    -montx 1 -monty 1 \
    -no_cor                                                                  \
    -prefix  FigureX_part_EPI_correct

  @djunct_edgy_align_check                                                     \
    -olay              wrong_anat_final.sub-021+tlrc.HEAD \
    -ulay              wrong_final_epi_vr_base+tlrc.HEAD                                     \
    -use_olay_grid     wsinc5                                                \
    -ulay_range_am     "1%" "95%"                                            \
    -ulay_min_fac      0.2                                                   \
    -set_dicom_xyz 22 28 44 \
    -save_ftype JPEG \
    -montx 1 -monty 1 \
    -no_cor                                                                  \
    -prefix  FigureX_part_EPI_wrong
```
