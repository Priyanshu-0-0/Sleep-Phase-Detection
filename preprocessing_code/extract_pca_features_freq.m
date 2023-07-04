% Code 9. extract_pca_features_freq.m --> FREQUENCY DOMAIN
% ------------------------------------------------------------------------
% This code extracts the pca components of the frequency domain from all the 
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
data_onesubj_freq = cell(subj_num,1);
data_allsubj_freq = [];

% Loop to append all the windows per subject in a cell
parfor i = 1:subj_num
    data_onesubj_freq{i}  = reshape_onesubj_freq (cell2mat(struct2cell(load([path, '//', dirinfo(i+4).name, '//', dirinfo(i+4).name, '.mat'],'val'))), win_samp, fsamp, channels);
    disp(i)
end

disp('-------------------------------------------')

% Loop to call each participant and append into a massive matrix
for subj = 1 : subj_num
    data_allsubj_freq = [data_allsubj_freq; data_onesubj_freq{subj}];
    disp(subj)
end

[coeff,score,latent,tsquared,explained,mu] = pca(data_allsubj_freq,'NumComponents',200);

% save("freq_pca.mat", "mu", "explained", "tsquared", "latent", "score", "coeff", "-v7.3")