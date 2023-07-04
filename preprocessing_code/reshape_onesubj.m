function [data_all_win]  = reshape_onesubj (data_all, win_samp,channels)

% Initialize storage needed
data_all_win = [];

for chan = channels 
    % Select data from current channel in the loop 
    data_ch = data_all(chan,:);
    
    % Eliminate outliers
    data_ch(abs(data_ch) > 10*(std(data_ch))) = 0;     
    
    % Normalise the PSD
    data_ch_norm = ( (data_ch - mean(data_ch))./max(abs(data_ch))); 

    % Reshape the data of each channel into windows
    [data_ch_wind] = reshape_onech (data_ch_norm, win_samp);

    % Append the PSD to an array
    data_all_win = [data_all_win, data_ch_wind];
end