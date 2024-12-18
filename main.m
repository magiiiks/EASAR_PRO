%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Pre data sorting  %
%%%%%%%%%%%%%%%%%%%%%%%%

% loading the dataset

folder_path = "../DSD100subset/Mixtures/Dev";

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

folder_path = "../DSD100subset/Sources/Dev";

audio_files = dir(folder_path);

% this is to delete the directory . .. and .DS_files(compulsory in mac)
% in windows i thing only needed . and .. so (3:end)
audio_files = audio_files(4:end);

num_files = length(audio_files);
audio_data_raw = cell(num_files, 4);
sample_rates_raw = zeros(num_files, 4);

for i = 1:num_files
    file_path = fullfile(folder_path, audio_files(i).name);
    audio_files1 = dir(file_path);

    % this is to delete the directory . .. and .DS_files(compulsory in mac)
    % in windows i thing only needed . and .. so (3:end)
    audio_files1 = audio_files1(3:end);
    for j = 1:length(audio_files1)
        file_path1 = fullfile(folder_path, audio_files(i).name,audio_files1(j).name)
        [audio_data_raw{i,j}, sample_rates_raw(i,j)] = audioread(file_path1);
    end
end

%%

% Generate example signals


x = audio_data{1}; % Input signal (e.g., noisy signal)
d = audio_data_raw{1,2}; % Desired signal

% Apply Wiener-Hopf filter
N = 50; % Filter order
[w, y_est] = wienerHopf(x, d, N);
n = 1:length(d);
n1 = 1:length(y_est);
% Plot results
figure;
plot(n, d, 'b', n1, y_est, 'r');
legend('Desired Signal', 'Estimated Signal');
title('Wiener-Hopf Filter Result');

%%

% Generate mixed signals (example)
t = 0:0.001:1;
s1 = sin(2*pi*10*t);
s2 = sin(2*pi*10*t);
A = [0.8 0.2; 0.3 0.7];
mixed_signals = A * [s1; s2];

% Apply the combined method
order = 10;
[separated_signals, prediction_coeffs] = levinsonDurbinBss(mixed_signals, order);

% Plot results
figure;
subplot(2,2,1); plot(t, mixed_signals(1,:)); title('Mixed Signal 1');
subplot(2,2,2); plot(t, mixed_signals(2,:)); title('Mixed Signal 2');
subplot(2,2,3); plot(t, separated_signals(1,:)); title('Separated Signal 1');
subplot(2,2,4); plot(t, separated_signals(2,:)); title('Separated Signal 2');




