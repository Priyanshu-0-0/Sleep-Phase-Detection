% Function 2.- import_labels.m
%------------------------------------------------------------------
% This function calls the arousal files and creates the labels of the 
% windows of the participant in turn. This function makes sure the number 
% of windows is exact (not a decimal value)
%------------------------------------------------------------------
function labels_windows = import_labels(filename,fs,size_signal,path)
    % Assign directory for arousal files   
    dir_arousal = append(path,'\',filename,'\',filename,'-arousal.mat');
    % Call arousal file for the participant
    arousal = load(dir_arousal).data.sleep_stages;  
    % Initiate array to store the labels for each window
    labels = zeros(length(arousal.wake),1);                 
    
    % Assign a numerical value to each stage
    for i = 1:length(arousal.wake)
        if arousal.wake(i)==1               % WAKE -- 1
        labels(i) = 1;
        elseif arousal.nonrem1(i)==1        % NREM1 - 2
        labels(i) = 2;
        elseif arousal.nonrem2(i)==1        % NREM2 - 3
        labels(i) = 3;
        elseif arousal.nonrem3(i)==1        % NREM3 - 4
        labels(i) = 4;
        elseif arousal.rem(i)==1            % REM --- 5
        labels(i) = 5;
        else                                % Undef - 6
        labels(i) = 6;
        end
    end
    
    window_sec = 30;                                        % Assign window length
    window_size = window_sec*fs;                            % Calculate size of the window
    num_windows = floorDiv(size_signal,window_size);        % Number of windows in the signal (exact value)

    labels = labels(1:num_windows*window_size,:);           % Make sure length of data is dividable
    labels = reshape(labels,[window_size,num_windows]);     % Reshape to [window_size,num_windows]
    labels_windows = zeros(num_windows,1);                  % Initiate label_windows array

    % For loop to generate the labels per window
    for i = 1:num_windows
        lab = mode(labels(:,i));
        labels_windows(i)=lab;
    end
end
