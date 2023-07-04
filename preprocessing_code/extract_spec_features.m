% Function 5. extract_spec_features.m
% ------------------------------------------------------------------------
% This function requires a few arguments, the signal divided in windows,
% number of windows in the signal, sampling frecuency, number of channels
% and the threshold for the spindle detection.
% 
% This function calculates the Power Spectrum Density spectogram and
% develops a series of features found in the literature. In addition, this
% function calculates the number of sleep spindles per window and appends
% everything into an array.
% 
% The size of the array will be (num_windows,17*num_channels)
% This code calculate 17 features per channel 
% ------------------------------------------------------------------------

function features = extract_spec_features(windowed_signal,num_windows,fs,num_channels,thresh_spindles)
    % Initialize features and spindle array
    features = zeros(num_windows,68);
    spindles = zeros(1,num_channels);

    % Assign parameters for PSD
    pwelch_window = fs; % 1 second
    pw_overlap = round(0.2*pwelch_window);
    NFFT = max(256,2^nextpow2(length(pwelch_window)));

    for window = 1:num_windows
        % Call data with windows
        data = windowed_signal(window,:,:);

        % Separate one window for the loop
        data = reshape(data,[size(windowed_signal,3),size(windowed_signal,2)]);
        
        % Calculate PSD
        [pxx, freq] = pwelch(data, pwelch_window, pw_overlap, NFFT, fs);

        % Extract power for each band
        bands_f = [1, 4, 8, 12, 16, 30];    % Hz
        delta = sum(pxx(freq >= bands_f(1) & freq <= bands_f(2),:),1);
        theta = sum(pxx(freq >= bands_f(2) & freq <= bands_f(3),:),1);
        alpha = sum(pxx(freq >= bands_f(3) & freq <= bands_f(4),:),1);
        sigma = sum(pxx(freq >= bands_f(4) & freq <= bands_f(5),:),1);
        beta =  sum(pxx(freq >= bands_f(5) & freq <= bands_f(6),:),1);
        
        % START FEATURE EXTRACTION
        % Absolute spectral power in the 0.4-30 Hz band -> (1x4)
        all_bands = [delta;theta;alpha;sigma;beta];
        abs_pwr_all_bands = sum(all_bands,1);

        % Relative spectral power in the frecuency bands -> (5x4)
        relative_pwr_per_band = all_bands./sum(all_bands);

        % Calculate ratios proposed
        d_b = delta./beta;
        d_s = delta./sigma;
        d_t = delta./theta;
        d_a = delta./alpha;
        a_t = alpha./theta;
        a_b = alpha./beta;
        a_s = alpha./sigma;
        b_s = beta./sigma;
        b_t = beta./theta;
        s_t = sigma./theta;

        % Sleep Spindles -> (1x4)
        for chan = 1:num_channels
            data_channel = data(:,chan);
            [wlt,f] = cwt(data_channel,fs);
            wlt_useful = wlt(1,:);
            analytic = conv(data_channel,wlt_useful,'same');
            magnitude = abs(analytic);
            power = magnitude.^2;
            norm_power = normalize(power,'range');
            [peaks,locs] = findpeaks(norm_power,fs,'MinPeakHeight',thresh_spindles);
            spindles(1,chan) = length(locs);
        end


        %-----------------------------------------------------------------
        % Feature matrix
        features_per_wind = [abs_pwr_all_bands;relative_pwr_per_band;a_t;a_b;a_s;b_s;b_t;s_t;d_b;d_s;d_t;d_a;spindles];
        
        % 17 features per channel, 4 channels --> 68 spectral features
        features_per_wind = reshape(features_per_wind,[1,68]);    % All values horizontally
        features(window,:) = features_per_wind;
    end
end