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
        file_path1 = fullfile(folder_path, audio_files(i).name,audio_files1(j).name);
        [audio_data_raw{i,j}, sample_rates_raw(i,j)] = audioread(file_path1);
    end
end

%%

% Generate example signals


x = audio_data{1}; % Input signal (e.g., noisy signal)
d = audio_data_raw{1,4}; % Desired signal

sound(x, sample_rates(1));
pause(length(x)/fs + 1);

% Apply Wiener-Hopf filter
N = 64; % Filter order
[w, y_est] = wienerHopf(x, d, N);

n = 1:length(d);
n1 = 1:length(y_est);

sound(y_est, sample_rates(1));

% Plot results
figure;
plot(n, d, 'b', n1, y_est, 'r');
legend('Desired Signal', 'Estimated Signal');
title('Wiener-Hopf Filter Result');

%%
x = audio_data{1};
fs = sample_rates(1);
% Perform LPC analysis
[residual, lpc_coeffs] = lpc_analysis(x, 12, 3200, 1600);

% Apply blind source separation to the residual
[W, separated_residuals] = muk_bss(residual', 2, 100);

% Reconstruct separated sources
source1 = lpc_synthesis(separated_residuals(1, :), lpc_coeffs, 3200, 1600);
source2 = lpc_synthesis(separated_residuals(2, :), lpc_coeffs, 3200, 1600);

% Play or save separated sources
sound(source1, fs);
sound(source2, fs);
%audiowrite('source1.wav', source1, fs);
%audiowrite('source2.wav', source2, fs);
