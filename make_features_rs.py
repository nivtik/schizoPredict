# Genertating a connectivity matrix for each participant in "patients" and "controls" list based on a given parcellation (orignially used the schaefer schaefer2018_100Parcels_7Networks parcellation)

import nibabel as nib
import numpy as np
import pandas as pd
from scipy import stats, linalg
import matplotlib.pyplot as plt

### Edit variables below ###
features_path = 'path_to_features_names.txt' # See example in classification examples folder
patients_pat h= 'path_to_patient_suject_numbers.txt' # See example in classification examples folder
controls_path = 'path_to_controls_suject_numbers.txt' # See example in classification examples folder
parc_path = 'path_to_parcellation_file' # For Schaefer2018_100Parcels_7Networks_order_FSLMNI152_2mm.nii.gz
label_data_path = 'path_to_atlas_labels.txt' # For example Schaefer_100parcels_7Network.txt
###

feature_names = [line.rstrip('\n') for line in open(features_path)]
patients = [line.rstrip('\n') for line in open(patients_path)]
controls = [line.rstrip('\n') for line in open(controls_path)]
all_subs = patients + controls
features = pd.DataFrame(index=all_subs, columns=feature_names)
target = ['1' for i in range(len(patients))] + ['0' for i in range(len(controls))]


parc = nib.load(parc_path).get_data().flatten()
labels = np.unique(parc)[1:]

label_data = pd.read_csv(label_data_path, sep='\t', header=None)
label_data = label_data.iloc[:, :2]
label_data.columns = ['label_num', 'label_name']

for i, sub in enumerate(all_subs):
    print(sub)
    
    ### Edit path below
    nif_path = f'path_to_perprocessed_resting_state_folder/sub-{sub}.feat/path_to_preprocessed_resting_state_data_in_standard_space'
    ###

    data = nib.load(nif_path).get_data()
    data = data.reshape(data.shape[0] * data.shape[1] * data.shape[2], data.shape[3])

    parcelated_dtseries = np.zeros((len(labels), data.shape[1]))

    for label in label_data.label_num:
        area_dtseries = np.mean(data[parc == label, :], axis=0)
        parcelated_dtseries[int(label) - 1, :] = area_dtseries

    corr_mat = np.corrcoef(parcelated_dtseries)
    ### Edit path below
    np.savetxt(f'path_to_output_directory/{sub}_corr_mat.txt', corr_mat, delimiter=',')
    ###

    sub_features = []
    for i in range(int(len(label_data)/2)):
        others = list(range(len(labels)))
        others.remove(i)
        for j in others:
            sub_features.append(corr_mat[i,j])
    features.loc[sub]=sub_features




