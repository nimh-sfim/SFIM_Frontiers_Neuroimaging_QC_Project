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
afni Frontiers_QC_2022/osfstorage-archive/fmri-open-qc-task/sub-001/ses-01/anat/sub-001_T1w.nii.gz
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
These depend on many environment variables.
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
