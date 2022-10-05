# Instructions

These are the instructions provided to the people who did the QC.

# Table of Contents

1. [Initial Visual Inspection](#initial-visual-inspection)
2. [Setup Shell Environment](#setup-shell-environment)
3. [Download and Organize Data](#download-and-organize-data)
4. [Add Slice Times to Niftis](#add-slice-times-to-niftis)
5. [Run Freesurfer](#run-freesurfer)

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
afni Frontiers_QC_2022/raw/fmri-open-qc-task/sub-001/ses-01/anat/sub-001_T1w.nii.gz
```
 
with the path to your subject’s anatomical or functional image.
In the viewer, make sure you can easily see all window panels.
For anatomical images, verify that you are looking at a human brain with no major visible abnormalities and enough image contrast to see white/grey matter separation.
For functional images, verify that you are looking at a human brain that looks like it would match the anatomical, and enough coverage to analyze all subcortical structures; the cerebellum may be missing.
Please also verify that there is a time series which appears to have no major distortions or artifacts in “video” mode or by scrolling through all timepoints.
For any abnormalities, upload a screenshot to the shared screenshot folder on OneDrive labeled `Screenshots_QA_Issues` in the `Initial_Visual_Inspection` subfolder.
Name your screenshot `sub-LABEL_[anat/func]_artifact`.

## Setup shell environment

There are many scripts set up to facilitate using bash to automate processes.
To retrieve them, clone the repository via

```
git clone https://github.com/nimh-sfim/SFIM_Frontiers_Neuroimaging_QC_Project.git
```

The scripts in this repository depend on many environment variables.
Consult `code/setup_template.sh` and create a template that matches your needs on your local system.
The template is set up for an 8-core, 16GB node from biowulf, NIH's HPC system.
To set up the environment, run

```
source setup_template.sh
```
in the code subdirectory.

## Download and Organize Data

You will need the osf client to fetch data.
You can obtain the OSF client with

```
pip install osfclient
```

in your preferred environment.
To fetch and organize data, run

```
./setup_data.sh
```

which requires an internet connection and the ability to access OSF.


## Add Slice Times to Niftis

AFNI can insert the slice times directly into the nifti files using the AFNI header extension.
This notably requires an AFNI installation.
To do this for all subjects, run

```
./add_slice_times.sh
```

which should take about 5 minutes.

## Run Freesurfer

Now you'll want to run freesurfer.
To do this, you'll need to specify a subject.
The script is set up to take values which are not 0-padded on [1, 30] and [101, 120].
Subjects less than 100 are task subjects, subjects more than 100 are rest rubjects.
To run freesurfer for a subject, run

```
./freesurfer_subj.sh $NUMBER
```

with `$NUMBER` the relevant subject number.
WARNING: even on biowulf, this takes 3.5 hours.
On some systems it may take considerably longer.
Consider batching these jobs.
Each run will requires about 300 MB of space.

## Convert freesurfer format to AFNI/SUMA format

Similar to freesurfer, you'll run a script for a given subject number.

```
./fs2suma.sh $NUMBER
```

which should take less than ten minutes per subject.

## Run SSwarper

SSwarper is responsible for transforming a skull-stripped brain into MNI space.

To run SSwarper, run

```
./warperizer.sh $NUMBER
```

with `$NUMBER` the relevant subject number.
WARNING: even on biowulf, this takes a considerable number of hours.
Consider batching these jobs.
Each run will require about 600MB of space.

## Inspect SSwarper

For SSwarper, navigate to the subject directory.
Check that the edges of color roughly match the T1 edges for `QC_AnatQQ_sub*.jpg`.
This indicates edge alignment between the template brain and the MNI-warped brain.
Additionally check that the red map covers the T1 brain for `QC_AnatSS.sub*.jpg`.
This indicates the extent of the T1 that is remaining after skullstripping.
If there are any noticeable errors, such as a gyrus edge being missed or inconsistent, note the slice in the image and upload the QC image.

## Run afni_proc

afni_proc is responsible for preprocessing and regression.

To run afni_proc for rest runs, run

```
./ap_rest.sh $NUMBER
```

with `$NUMBER` the relevant subject number.
This takes about 45 minutes and 2.7GB of space.

Similarly, for task data, run

```
./ap_task.sh $NUMBER
```

with `$NUMBER` the relevant subject number.
This takes about 50 minutes and 2.7GB of space.

## Inspect APQC

For afni_proc, we fortunately get a large summary of visuals and tables to easily inspect outputs.
The QC report can be found as `QC_sub-*/index.html` in each subject's afni_proc output directory.
Please check all of the following:
1. Skip ahead to "warns." If there is a severe left-right flip check warning and the edges on the map pictured appear out of alignment, perform a left-right flip on the EPI and re-run afni_proc.py (see "Perform a left-right EPI flip")
2. Ensure EPI ("Check vols in original space") and anatomical ("Anatomical in original space") look like the original expected (the anatomical should be skullstripped as in SSwarper outputs).
3. Check EPI to anatomical alignment (ve2a/"Check vol alignment (EPI to anat)"); edges should mostly match.
4. Check that anatomical to template alignment (va2t/"Check vol alignment (anat to template)") is a very close match. There should be no major differences, and the image should appear identical to the SSwarper output `QC_AnatSS*.jpg`.
5. Check that the EPI final mask covers most of the brain (in the same report section as the previous step).
6. Make sure that stat maps (vstat/"Check statistics vols (and effect estimates)") do not match any documented artifacts.
7. Repeat this inspection for seed-based correlation maps (in the same section as the previous step).
8. Check that motion and outliers do not exceed 20% (mot/"Check motion and outliers").
9. Check that tSNR does not drop below the 10th percentile, particularly in the image with the overlay indicating "final TSNR dset."
10. Check warnings section for any severe warnings. Note that general censor fraction warnings are more liberal in the final QC report than what is outlined here, so censor warnings may not appear.
For any check failures, please upload the relevant section of the report and mark the dataset as unusable.

## Perform a left-right flip

Left-right flips are surprisingly common between the EPI and anatomical datasets.
Because we spend much longer on processing the T1 than on the EPI, we will flip the EPI to match the T1 rather than vice versa when AFNI recommends that we do.
In order to perform the left-right flip, and re-run afni_proc run

```
$QC_CODE_ROOT/handle_lr_flip.sh $NUMBER
```

with `$NUMBER` the subject number.
This script will calculate a left-right flipped EPI dataset and run afni_proc using this data set rather than the original.
