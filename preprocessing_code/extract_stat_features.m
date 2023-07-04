% Function 4. extract_stat_features.m
% -------------------------------------------------------------------------
% This function only requires the windowed signal (only 30 seconds of the
% signal) and it calculates four statistical features: interquantile range,
% skewness, kurtosis and standard deviation, of the entire window.
% 
% Windowed_signal should have dimensions: 
% [number_channels,window_size]
% -------------------------------------------------------------------------

function features = extract_stat_features(windowed_signal)
    % Statistical features
    intqr = iqr(windowed_signal,[2,3]);
    skew = skewness(windowed_signal,0,[2,3]);
    kurt = kurtosis(windowed_signal,0,[2,3]);
    stdev = std(windowed_signal,0,[2,3]);
    features = [intqr skew kurt stdev];
end

% Features will have size: (number of windows,4) 

