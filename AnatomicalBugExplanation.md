# Description of processing error

Between our first submission and our revised submission, we noticed a serious
processing bug. Our script to run freesurfer mapped the anatomical images from
some subjects to subject IDs from other subjects. For the amusement and
education of anyone who finds this document, we decided to document exactly
what happened, and how we could have prevented it from happening.
(All irony of making a mistake like this as part of a QC education project
is duely noted. We prefer to think of this as a very unintentional
educational opportunity.)

## The scripting error

This repo was mostly written on a Mac and tested using the `zsh` shell. It
was run on our Linux computing cluster using `bash`. Many scripts run
identically in either, but there are subtle differences. For example,
`printf "%3.3d" $a_number` will print a 3 digit number that's zero padded.
That is 1 -> 001 and 10 -> 010.  The difference that affected our processing
is that in zsh, if the input is already a zero padded number, the zero padding is
ignored, but, in bash, a number that begins with a 0 is treated an octal
number and the printf command converts the base 8 number to a base 10 number. That is:

```bash
# zsh 
$ printf "%3.3d 7 
007 
$ printf "%3.3d 07 
007 
$ printf "%3.3d 10 
010 
$ printf "%3.3d 010 
010 
$ printf "%3.3d 8 
008 
$ printf "%3.3d 08 
008 

# bash 
$ printf "%3.3d 7 
007 
$ printf "%3.3d 07 
007 
$ printf "%3.3d 10 
010 
$ printf "%3.3d 010 
008 
$ printf "%3.3d 8 
008 
$ printf "%3.3d 08 
# error that outputs a “1” error code 
```

The scripts were written so that users inputted non-zero padded numbers and the
numbers were zero padded to create the subject IDs. This was done properly for
entering and creating the subject ID to use with freesurfer’s `recon-all` command, but
an already zero-padded number was re-padded when creating the path to the
anatomical scan to use. We ended up running commands like:

`recon_all –subjid sub-017 -i sub-015_T1w.nii.gz`

This issue only appeared in the task data with 1-2 digit IDs that ended up with
padded zeros and not in the rest data where every subject ID was already 3
digits and began with “1”. Additionally, this bug was actually identified and
fixed fairly early in data processing so it didn’t affect all task runs, but
not all runs were reprocessed with the fixed code, which made the issue even
more subtle.

## Ways to have prevented this problem

### Coding design

The same `printf` statment was used to zero pad the same numbers in multiple
places. This repetition is both inefficient coding design and made it possible
for the divergence we experienced to happen. Since this code uses multiple
scripts that all take a subject number as input, we could have called one script
that converted subject numbers to IDs. Then, if there was a mistake, certain
subjects would have run properly and certain would have never run, which would
have been a much more obvious failure.

### Processing instructions

Since this repo was designed as a teaching tool for fMRI quality control we
had three separate people run the scripts that could have easily been
submited to our cluster by a single person. This was to make sure the
instructions and explanations were clear. Unfortunately, this also resulted
in no centralized log of when each subject was run, who ran it. That meant the
early place to notice something was systematicaly odd wasn't checked.
Additionally, our Freesurfer QC was to make sure the brains were properly
skull stripped and they were (just not the right people's brains).
If all the output logs were stored in once place and our QC process included
skimming the top-line commands that were run, we would have immediately
noticed this issue.

### Visual QC

As we note in the manuscript, given the bug happened, the main place we should
have caught the bug was when we looked at the functional to anatomical alignments.
When we saw a subtle mis-alignment we looked carefully at the full anatomical and
EPI images to check if the issues were serious enough to warrant exclusion. When
the summary image for an alignment was obviously bad, we saw no reason to look
at the full volumes. We classified such runs as "unsure" quality since we knew
alignments could be improved, but we accomplished the educational goals for this
QC manuscript. This has implications for automated rejection criteria that may
remove data without probing more fundamental issues that might have caused
the problem.

### Additional checks

Even when closely inspected, the difference between a bad alignment and a wrong
anatomical is subtle. P Taylor of the AFNI team suggested that AFNI's alignment
with the local unifize option is now good enough that any time there are bad
alignments the first assumption should that there is an issue with the data
rather than an alignment failure. Through posthoc examination, we also
notice that the cost function minima are relative to each study but fairly consistent
within studies. For the task data, , when the correct anatomicals were used, the cost
function minima were between -0.089 and -0.29, but the values when the wrong anatomicals
were used were -0.02 to -0.07. For the rest data, the values were between -0.36 and -0.49
except for the two flipped L/R volumes (-0.11 -0.12) and the one where we think the
genuinely wrong anatomical was shared was: -0.075. This is worth more systematic evaluation
but a distrubtion of cost function minimal across subjects with the same acqusition parameters
may be useful for automatically detecting alignments-of-concern.