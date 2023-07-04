% Function 3.- filter_signals.m
%------------------------------------------------------------------
% This function need the signals, the channels used, frecuency of sampling
% and the filter values for the three proposed filters. The fiulter values
% should be calculated only one time (thats why we design them in the
% main).
% 
% The filtering process is done automatically, by detecting the type of
% signal using identifiers and appending them as they go inside the for
% loop.
% 
% MORE EXPLANATION IS UNDERNEATH THE FUNCTION. ******

% #############################################################################################################

function filtered_signals = filter_signals(signals,fs,channels,b1_l,b1_h,a1_l,a1_h,b2,a2,b3_l,b3_h,a3_l,a3_h)
    %--------------------------------------------------
    % Filter all given channels
    % EEG-1, E0G-2, EMG-3, EKG-4, Other-0 *********
    % Ids only match Physionet 2018 data *********
    id_channels = [1,1,1,1,1,1,2,3,0,0,0,0,4];

    % Array where we store the filtered signals
    filtered_signals = [];

    % Loop for detection of incoming signal to filter
    for i=1:length(channels)
        if id_channels(channels(i))==1              % Its EEG signal
            sig = filtfilt(b1_l,a1_l,signals(:,i));
            sig = filtfilt(b1_h,a1_h,sig);

        elseif id_channels(channels(i))==2          % Its EOG signal
            sig = filtfilt(b1_l,a1_l,signals(:,i));
            sig = filtfilt(b1_h,a1_h,sig);

        elseif id_channels(channels(i))==3          % Its EMG signal
            sig = filtfilt(b2,a2,signals(:,i));

        elseif id_channels(channels(i))==4          % Its EKG signal
            sig = filtfilt(b3_l,a3_l,signals(:,i));
            sig = filtfilt(b3_h,a3_h,sig);
        else
            sig = signals(:,i);                     % Signal with no filter
        end

        % Merge sig one after the other depending on channels chosen
        filtered_signals = [filtered_signals,sig];
    end
end

% #############################################################################################################

% ********* The id_channels list was created only for the use of the
% Physionet 2018 Dataset and it represents a identifier for each of the 
% different signals in each participant

% |    CHANNELS    |   IDS   |
% ---------------------------
% 1. F3-M2 --------> EEG - 1
% 2. F4-M1 --------> EEG - 1
% 3. C3-M2 --------> EEG - 1
% 4. C4-M1 --------> EEG - 1
% 5. O1-M2 --------> EEG - 1
% 6. O2-M1 --------> EEG - 1
% 7. E1-M2 --------> EOG - 2
% 8. Chin1-Chin2 --> EMG - 3
% 9. ABD ---------->     - 0
% 10. CHEST ------->     - 0
% 11. AIRFLOW ----->     - 0
% 12. SaO2 -------->     - 0
% 13. ECG ---------> EKG - 4

% The for loop only filters the signals that have a identifier different
% from zero and it detectes which filter should be used depending on the
% value of 'i'