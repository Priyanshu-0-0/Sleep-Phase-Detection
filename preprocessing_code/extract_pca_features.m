% Code 8. extract_pca_features.m --> TIME DOMAIN
% ------------------------------------------------------------------------
% This code extracts the pca components of the time series from all the 
% subjects. First we extract each of the windows of the participants,
% then we create a massive matrix of all the channels and participants
% one below the other, and finally we calculare the Principal Components
% Analysis (PCA) of this matrix to obtain the most amount of information
% in a smaller dimension.
% ------------------------------------------------------------------------

load("dirinfo.mat")
path = '//home//mv22003//sleep_classifier//training';   % Cluster path

%  Assign values 
win_sec = 30;                       % Window size in seconds
fsamp = 200;                        % Sampling frecuency
win_samp = win_sec * fsamp;         % Size of window in frequency
channels = 1:13;                    % Channels selected
num_channnels = length(channels);   % Number of channels selected
subj_num = size(dirinfo,1) - 2;     % Number of subjects in training set

% Initialize both spaces of storage required
data_onesubj_win = cell(subj_num,1);
data_allsubj_win = [];

% Loop to append all the windows per subject in a cell
for subj = 1 : subj_num
    disp(subj)
    data_onesubj_win{subj} = reshape_onesubj (cell2mat(struct2cell(load([path, '//', dirinfo(subj+2).name, '//', dirinfo(subj+2).name, '.mat'], 'val'))), win_samp,channels);    
end

disp('-------------------------------------------')

% Loop to call each participant and append into a massive matrix
for subj = 1 : subj_num
    data_allsubj_win = [data_allsubj_win; data_onesubj_win{subj}];
    disp(subj)
end

[coeff,score,latent,tsquared,explained,mu] = pca(data_allsubj_win,'NumComponents',200);

% save("time_pca.mat", "mu", "explained", "tsquared", "latent", "score", "coeff", "-v7.3")