% Function 1.- load_data.m
%------------------------------------------------------------------
% This function loads the data of the selected channels
% of the specficied filename. I.e.: if filename is 'tr03-0005',
% the return will be the signals of that participants and the
% selected channels. Dimensions -> (points in recording, channels)
%------------------------------------------------------------------
function signals = load_data(filename,path,channels)
    % Append the path of the .mat file we desire
    dir_signal = append(path,'\\',filename,'\\',filename,'.mat');

    % Load the data of the path, we only need .val from data
    data = load(dir_signal).val;

    % Store channels requested from data, in variable signal
    signals = data(channels,:).';
end