%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Pre data sorting  %
%%%%%%%%%%%%%%%%%%%%%%%%

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

folder_path = "../DSD100subset/Sources/Dev";
audio_files = dir(folder_path);

% this is to delete the directory . .. and .DS_files(compulsory in mac)
% in windows i thing only needed . and .. so (3:end)
audio_files = audio_files(3:end);

num_files = length(audio_files);
audio_data_raw = cell(num_files, 4);

for i = 1:num_files
    file_path = fullfile(folder_path, audio_files(i).name);
    audio_files1 = dir(file_path);

    % this is to delete the directory . .. and .DS_files(compulsory in mac)
    % in windows i thing only needed . and .. so (3:end)
    audio_files1 = audio_files1(3:end);
    for j = 1:length(audio_files1)
        file_path1 = fullfile(folder_path, audio_files(i).name,audio_files1(j).name);
        audio_data_raw{i,j} = audioread(file_path1);
    end
end

fprintf('Pre-Data sorting ended');

%%

%Wiener-Hopf
% Generate example signals
duration_seconds = 7;

% x = audio_data{1}; % Input signal (e.g., noisy signal)
x = audio_data_raw{2,4} + audio_data_raw{2,2}; % blending 2 audio files
%x = audio_data{2};
x = x / max(abs(x(:))); % normalize to prevent clipping

d = audio_data_raw{2,4}; % Desired signal
d = d / max(abs(d(:))); %Normalize to prevent clipping

% Apply Wiener-Hopf filter
N = 64; % Filter order

%APPLYING THE ALGORITHM
fprintf('Wiener-Hopf filtering \n');
tic;
[w, y_est] = wienerHopf(x, d, N);
elapsed_time = toc;
fprintf('Wiener-Hopf took: %u \n', elapsed_time);

%Renormalizing the filtered signal in case it has peaked.
y_est = y_est / max(abs(y_est));

%Hearing the blended original.
fprintf('Playing the unfiltered blended one...\n');
num_samples = duration_seconds * sampling_rate;
x_short = x(1:min(num_samples, length(x)));

sound(x_short, sampling_rate);
pause(length(x_short) / sampling_rate + 1);

%Hearing the filtered one.
fprintf('Playing the filtered signal...\n');
y_est_short = y_est(1:min(num_samples, length(y_est)));
sound(y_est_short, sampling_rate);
pause(length(y_est_short) / sampling_rate + 1);

n = 1:length(d);
n1 = 1:length(y_est);

% Plot results
figure;
plot(n, d, 'b', n1, y_est, 'r');
legend('Desired Signal', 'Estimated Signal');
title('Wiener-Hopf Filter Result');

%%
frame_length = 1024;
p = 10; % AR model order
n_frames = floor(length(x) / frame_length);
ar_coeffs = zeros(p+1, n_frames);

for i = 1:n_frames
    frame = x((i-1)*frame_length + 1 : i*frame_length);
    r = xcorr(frame, p, 'biased');
    a = levinsonDurbin(r(p+1:end));
    ar_coeffs(:, i) = a;
end

% Perform blind source separation
B = x(1:n_frames*frame_length);
B = reshape(B, frame_length, n_frames)';
[S, ~, ~] = fastica(B, 2);

% Reconstruct separated signals
reshaped = reshape(S(:, 1), 1, []);
%s2 = reshape(S(:, 2), 1, []);

% Apply AR model to enhance separated signals
reshaped = filter(1, ar_coeffs(:, 1), reshaped);
%enhanced_s2 = filter(1, ar_coeffs(:, 2), s2);

% Normalize and play results
reshaped = reshaped / max(abs(reshaped));
%enhanced_s2 = enhanced_s2 / max(abs(enhanced_s2));

sound(enhanced_s1, sample_rates{1});
%pause(length(enhanced_s1)/fs1);
%sound(enhanced_s2, fs1);
