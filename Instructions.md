# Instructions

These are the instructions provided to the people who did the QC.

# Table of Contents

1. [Initial Visual Inspection](#initial-visual-inspection)

## Initial Visual Inspection

Navigate to your assigned subjects on the shared drive.
Resting state subjects will be located in fmri-open-qc-rest.
Task subjects will be located in fmri-open-qc-task.
Each is organized in BIDS format, so that each subject has their own directory (sub-LABEL) and a session subdirectory (ses-LABEL) containing anatomical images in the anat/ subdirectory and functional images in the func/ subdirectory.
Please navigate to a subject directory and launch the AFNI viewer (your session will need to be remote desktop or allow X-window forwarding for this).
Use the command

```
afni path/to/image
```
 
Example:
```
afni Frontiers_QC_2022/osfstorage-archive/fmri-open-qc-task/sub-001/ses-01/anat/sub-001_T1w.nii.gz
```
 
with the path to your subject’s anatomical or functional image.
In the viewer, make sure you can easily see all window panels.
For anatomical images, verify that you are looking at a human brain with no major visible abnormalities and enough image contrast to see white/grey matter separation.
For functional images, verify that you are looking at a human brain that looks like it would match the anatomical, and enough coverage to analyze all subcortical structures; the cerebellum may be missing.
Please also verify that there is a time series which appears to have no major distortions or artifacts in “video” mode or by scrolling through all timepoints.
For any abnormalities, upload a screenshot to the shared screenshot folder on OneDrive labeled `Screenshots_QA_Issues` in the `Initial_Visual_Inspection` subfolder.
Name your screenshot `sub-LABEL_[anat/func]_artifact`.
