# schizoPredict

Codes for fMRI preprocessing and individual statistical anaslysis, and classification between patients and controls (Tik et al., 2020).

The provided codes are using the following:
1. FMRIB Software Library (Jenkinson et al., 2012), including FEAT (Woolrich et al., 2001) and FIX (Griffanti et al., 2014).
2. Schaefer2018_100Parcels_7Networks parcellation (Schaefer et al., 2018). 

The following are provided:

Task activation prediction codes:

1. preproc_stats.sh: bash script for preprocessing and statistical analysis for a single participant (script dependencies may be found in the feat directorty).
2. For prediction process see Tavor et al., 2016.

Classificaion codes:

1. make_features_rs.py: feature extraction (atlas based functional connectivity matrices).
2. SCZ_classify.ipynb: classification (requires features for all participants and a labeling file).

Examples:

1. nifti folder containing defaced anatomical T1w image, resting_state and Nback task data for a single example participant.
2. classificaton examples folder: Example text files for make_features_rs.py

Refrences:
1. M. Jenkinson, C.F. Beckmann, T.E. Behrens, M.W. Woolrich, S.M. Smith. FSL. NeuroImage, 62:782-90, 2012
2. M.W. Woolrich, B.D. Ripley, M. Brady, S.M. Smith. Temporal Autocorrelation in Univariate Linear Modeling of FMRI Data. NeuroImage, 14(6):1370–1386. 2001
3. G. Salimi-Khorshidi, G. Douaud, C.F. Beckmann, M.F. Glasser, L. Griffanti S.M. Smith. Automatic denoising of functional MRI data: Combining independent component analysis and hierarchical fusion of classifiers. NeuroImage, 90:449-68, 2014
4. L. Griffanti, G. Salimi-Khorshidi, C.F. Beckmann, E.J. Auerbach, G. Douaud, C.E. Sexton, E. Zsoldos, K. Ebmeier, N. Filippini, C.E. Mackay, S. Moeller, J.G. Xu, E. Yacoub, G. Baselli, K. Ugurbil, K.L. Miller, and S.M. Smith. ICA-based artefact removal and accelerated fMRI acquisition for improved resting state network imaging. NeuroImage, 95:232-47, 2014
5. A. Schaefer, R. Kong, E.M. Gordon, T.O. Laumann, X.N. Zuo, A.J. Holmes, et al. Local-Global Parcellation of the Human Cerebral Cortex from Intrinsic Functional Connectivity MRI. Cereb Cortex 28: 3095–3114. 2018
6. I. Tavor, O., Parker Jones, R.B. Mars, S.M. Smith, T.E. Behrens, S.Jbabdi. Task-free MRI predicts individual differences in brain activity during task performance. Science 352: 216–20. 2016
