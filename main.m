%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Pre data sorting  %
%%%%%%%%%%%%%%%%%%%%%%%%

% loading the dataset

folder_path = "../DSD100subset/Mixtures/Dev";
file_pattern = fullfile(folder_path, '*.wav'); 

audio_files = dir(folder_path);

% this is to delete the directory . .. and .DS_files(compulsory in mac)
% in windows i thing only needed . and .. so (3:end)
audio_files = audio_files(4:end);

num_files = length(audio_files);
audio_data = cell(num_files, 1);
sample_rates = zeros(num_files, 1);

for i = 1:num_files
    file_path = fullfile(folder_path, audio_files(i).name,'/mixture.wav');
    [audio_data{i}, sample_rates(i)] = audioread(file_path);
end





