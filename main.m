%% DEMIXING OF AUDIO SIGNALS. BY MAGÍ & CARLOS RUEDA. EASAR

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Pre data processing  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% loading the dataset
folder_path = "../DSD100subset/Mixtures/Dev";
audio_files = dir(folder_path);
sampling_rate = 44100;

% this is to delete the directory . .. and .DS_files(compulsory in mac)
% in windows i thing only needed . and .. so (3:end)
audio_files = audio_files(4:end);

num_files = length(audio_files);
audio_data = cell(num_files, 1);

for i = 1:num_files
    file_path = fullfile(folder_path, audio_files(i).name,'/mixture.wav');
    audio_data{i} = audioread(file_path);
end

folder_path = "../DSD100/Sources/Dev";
audio_files = dir(folder_path);

% This is to delete the directory . .. and .DS_files(compulsory in mac)
% in windows i thing only needed . and .. so (3:end)
audio_files = audio_files(4:end);

num_files = length(audio_files);
audio_data_raw = cell(num_files, 4);

for i = 1:num_files
    file_path = fullfile(folder_path, audio_files(i).name);
    audio_files1 = dir(file_path);

    % This is to delete the directory . .. and .DS_files(compulsory in mac)
    % in windows i thing only needed . and .. so (3:end)
    audio_files1 = audio_files1(3:end);
    for j = 1:length(audio_files1)
        file_path1 = fullfile(folder_path, audio_files(i).name,audio_files1(j).name);
        audio_data_raw{i,j} = audioread(file_path1);
    end
end

fprintf('Pre-Data sorting ended\n');

%% Main algorithm.

%%%%%%%%%%%%%%%%%%%%%
% 2. MAIN ALGORITHM %
%%%%%%%%%%%%%%%%%%%%%

% Itering all the audio archives.
for i = 1:length(audio_files)
    % Blending the drums+vocals audio files and normalizing it to prevent
    % clipping.
    x = audio_data_raw{i,4} + audio_data_raw{i,2}; 
    x = x / max(abs(x(:)));
    
    % Getting the desired signal and normalizing it to prevent clipping
    d = audio_data_raw{i,4};
    d = d / max(abs(d(:)));
    
    fprintf('Main algorithm started... %d \n',i);
    filtering(x,d,sampling_rate, audio_files(i).name)
end

%% Primitive testing.

x = audio_data_raw{i,4} + audio_data_raw{i,2}; % blending 2 audio files voice and drums
x = x / max(abs(x(:))); % normalize to prevent clipping

d = audio_data_raw{i,4}; % Desired signal
d = d / max(abs(d(:))); %Normalize to prevent clipping

fprintf('Wiener-Hopf filtering: %d \n',i);
filtering_sound(x,d,sampling_rate)