# Preprocessing and individual task analysis

#Prerequisits:
# FSL. for more details see https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/
# FIX (R is also for FIX). for more details see: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FIX

# Note: To use the output to perform prediction of task-evoked brain activity from resting-state data,  the preprocessed fMRI 4D nifti images and the contrast zstat maps should be trasformed to 91282 "grayordinates" space using 
# the wb_command: -volume-to-surface-mapping in Connectom_Workbench. for more details see: https://www.humanconnectome.org/software/connectome-workbench 

# Defining Variables

# rootdir: full Path to the folder containing the example data and all and all scripts This path should contain 3 sub-folders 
# nifti: contains the participant's data: fMRI 4D nifti image, and high resolution anatomical T1w image. 
# bash_scripts
# feat_designs: One design for preprocessing and one for task analysis. These should be modifed to fit the data (Can be done by editing the text or by using the feat_gui in FSL)


# Input arguments:
# subjnum: Following Brain Imaging Data Structure (BIDS) organization (e.g sub-001)
# fixdir: full path to fix directory
# fix_threshold: determined by the user according to your the specific dataset. gets one of the following values: 1,2,5,10,20,30,40,50
# data_type: string that states: "task" or "rest"

rootdir=$1 
subjnum=$2
fixdir=$3
fix_threshold=$4
data_type=$5

fsldir=/usr/local/fsl # Change if different in your system

T1=${rootdir}/nifti/${subjnum}/anat/${subjnum}_T1w.nii.gz 
fMRI=${rootdir}/nifti/${subjnum}/func/${subjnum}_task-nback_bold.nii.gz # change to different task or rest if necessary
outdir=${rootdir}/outdir/${subjnum}
mkdir $outdir

echo "subjfolder=" ${subj}
echo "T1=" ${T1}
echo "fMRI=" ${fMRI}
echo outdir= ${outdir}

# Copying files to outputdir
cp ${T1} ${outdir}/${subjnum}_T1w.nii.gz
cp ${fMRI} ${outdir}/${subjnum}_task-nback_bold.nii.gz

# Run brain extraction
echo "Run BET"
bet ${T1} ${outdir}/${subjnum}_T1w_brain.nii.gz -f 0.2 -B

# Preprocessing using FSL's FEAT incuding
echo "Run FEAT and MELODIC"
feat ${rootdir}/feat/Preproc_${subjnum}.fsf

# Denoising using FIX (Including cleanup of 24 motion regressors)
# Note: FIX needs to be trained on your own data to prior to usage. 
echo "Run FIX denosing"
${fixdir}/fix  ${outdir}.feat ${rootdir}/feat/Nback_training.RData ${fix_threshold} -m -h 0.01

# Apply pre-calculated transformation to MNI space
echo "Apply MNI transformation"
applywarp -i ${outdir}.feat/filtered_func_data_clean.nii.gz -o ${outdir}.feat/filtered_func_data_clean_MNI.nii.gz -r ${fsldir}/data/standard/MNI152_T1_2mm_brain.nii.gz -w ${outdir}.feat/reg/example_func2standard_warp.nii.gz

### The next part is relevant for task analysis only ###
if data_type="task"
then
	# Individual task statistics
	feat /Volumes/homes/nivtik/Research/Schizo/Codes_for_share/feat/task_analysis.fsf
	 
	# Transforming stats to MNI space
	applywarp -i ${outdir}_stats.feat/stats/zstat1.nii.gz -o ${outdir}_stats.feat/stats/zstat1_MNI.nii.gz  -r ${fsldir}/data/standard/MNI152_T1_2mm_brain.nii.gz -w ${outdir}.feat/reg/example_func2standard_warp.nii.gz
fi


