function [data_ch_wind] = reshape_onech (data_ch, win_samp)
    % Calculate number of possibel windows (decimal)
    num_win30_dec = size(data_ch,2) / win_samp;

    % Calculate the exact number of windows
    num_win30 = floor (num_win30_dec);

    % Delimit signal so that windows are exactly 30secs long
    if num_win30_dec > num_win30
      valid_samples = num_win30 * win_samp;
      data_ch(valid_samples+1 : end) = [];
    end
    
    % Reshape signal with number of windows calculated
    data_ch_wind = reshape(data_ch, [win_samp, num_win30])';
end