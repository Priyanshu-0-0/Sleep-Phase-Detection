% Function 6. extract_all.m
% ------------------------------------------------------------------------
% This function extracts everything we need to do the process of extraction
% for both statistical and spectral features. This function was created to
% be called in a parallel processing loop in a High Perfomance Cluster (HPC).
% The result of this function is a matrix with total number of windows of 
% the participants and 72 features. Finally we have the option of merging 
% this feature matrix with labels or not.
% ------------------------------------------------------------------------

function data = extract_all(participant,path,channels,dirinfo,fs,window_sec,thresh_spindles,b1_l,b1_h,a1_l,a1_h,b2,a2,b3_l,b3_h,a3_l,a3_h)
    % Select current file
    filename = dirinfo(participant).name;
    window_size = window_sec*fs;
    num_channels = length(channels);

    % Extract signals and filtered them
    signals = load_data(filename,path,channels);                % Extract four channels per subject
    filtered_signals = filter_signals(signals,fs,channels,b1_l,b1_h,a1_l,a1_h,b2,a2,b3_l,b3_h,a3_l,a3_h);   % Filter signals
    size_signal = size(filtered_signals,1);                     % Size fo the current signal

    % Extract the labels for each window
    labels = import_labels(filename,fs,size_signal,path);   
    
    % Divide signal into windows
    num_windows = floor(size(filtered_signals,1)/window_size);

    % Make sure length of data is dividable
    filtered_signals = filtered_signals(1:num_windows*window_size, :);

    % Reshape signals correctly 
    % [Number of Windows, Number of Channels, Window Size]
    windowed_signal = reshape(filtered_signals,[num_windows,num_channels,window_size]); 

    % Extract statistical features
    stat_features = extract_stat_features(windowed_signal);     % [num_windows,4]

    % Extract spectral features
    spec_features = extract_spec_features(windowed_signal,num_windows,fs,num_channels,thresh_spindles);     % [num_windows,68]

    % Merge data and labels or only data
    data = [stat_features,spec_features,labels];    % (num_windows,73)
    % data = [stat_features,spec_features];         % (num_windows,72)
end