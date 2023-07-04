function [data_all_win_freq]  = reshape_onesubj_freq (data_all, win_samp, fsamp,channels)

% Initialize storage needed
data_all_win_freq = [];

pwelch_window = fsamp;                              % 200Hz --> 1 second
pw_overlap = round(0.2*pwelch_window);              % Calculate overlap for PSD
NFFT = max(256,2^nextpow2(length(pwelch_window)));  % Calculate NFFT for PSD
sample_40Hz = ceil((45/(fsamp/2))*(NFFT/2));        % Value used to delimit PSD to first 40Hz

for chan = channels   
    % Select data from current channel in the loop
    data_ch = data_all(chan,:);
    
    % Reshape the data of each channel into windows
    [data_ch_wind] = reshape_onech (data_ch, win_samp);
    
    % Calculate PSD using pwelch function
    [pxx, freq] = pwelch(data_ch_wind', pwelch_window, pw_overlap, NFFT, fsamp);

    % Recollect the useful part of the PSD
    pxx_useful = log10(pxx');                                               % Logaritmic value of pxx
    pxx_useful = pxx_useful(:, 1:sample_40Hz );                             % Delimit pxx below 40Hz
    pxx_useful( (abs(pxx_useful') > 10*(std(pxx_useful')))' ) = 0;          % Eliminate outliers
    pxx_useful_norm = ( (pxx_useful)  ./ max(abs(pxx_useful),[],2) );       % Normalise the PSD
    pxx_useful_norm = (pxx_useful_norm - mean(pxx_useful_norm, 2) ) ;       % 

    % Append the PSD to an array
    data_all_win_freq = [data_all_win_freq, pxx_useful_norm];

end