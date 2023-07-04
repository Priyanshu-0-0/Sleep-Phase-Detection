% Code 7. main_cluster.m
% ------------------------------------------------------------------------
% This main code runs a parallel processing loop and extracts all the 
% features for each of the windows of each of the subjects. 
% ------------------------------------------------------------------------

% Load directory info for management of filenames
load dirinfo.mat dirinfo

% Assign directory for training dataset 
path = 'F:\\Group 19\\Challenge_dataset\\training';         % LOCAL path
% path = '\\home\\mv22003\\sleep_classifier\\training';     % CLUSTER path

% Assign values for functions
fs = 200;                   % Sampling frecuency
channels = [3,7,8,13];      % EEG, EOG, EMG, EKG
window_sec = 30;            % Size of windows in seconds
thresh_spindles = 0.25;     % Threshold for sleep spindle detection from normalized voltage

% Assign space to store features
data = cell(size(dirinfo,1)-4, 2);

%----------------------------------------------------
% Design filter for each channel (each signal)
%----------------------------------------------------
% EEG and EOG filter - Bandpass 0.5-30Hz - 10th Order
wn1_low = 30/(fs/2);
wn1_high = 0.5/(fs/2);
[b1_l,a1_l] = butter(10,wn1_low,'low');
[b1_h,a1_h] = butter(2,wn1_high,'high');

% EMG filter - Highpass 20Hz - 8th Order
wn2 = 20/(fs/2);
[b2,a2] = butter(8,wn2,'high');

% EKG filter - Bandpass 1-50Hz - 8th Order
wn3_low = 50/(fs/2);
wn3_high = 1/(fs/2);
[b3_l,a3_l] = butter(8,wn3_low,'low');
[b3_h,a3_h] = butter(8,wn3_high,'high'); 
%------------------------------------------------------

% Parallel for loop to extract the features per participant
% using the extract_all function created and appending in a 
% cell array
parfor subj=1:size(dirinfo,1)
    current_data = extract_all(subj+4,path,channels,dirinfo,fs,window_sec,thresh_spindles,b1_l,b1_h,a1_l,a1_h,b2,a2,b3_l,b3_h,a3_l,a3_h);
    data(subj,:) = {current_data, dirinfo(subj+4).name};
    disp(subj)
end

% save('all_features_labels.mat','data')
