function filtering_sound(x, d, sampling_rate, name)
    %APPLYING BAND-PASS FILTER (3kHz).
    % Define filter parameters
    lowFreq = 125;  % Lower cutoff frequency in Hz
    highFreq = 3000;  % Upper cutoff frequency in Hz
    filterOrder = 4;  % Filter order
    duration_seconds = 7; %DUration in seconds

    % Normalize the frequencies
    nyquist = sampling_rate/2;
    Wn = [lowFreq highFreq] / nyquist;

    % Design the bandpass filter
    [b, a] = butter(filterOrder, Wn, 'bandpass');

    x = filter(b, a, x);

    %Wiener-Hopf

    % Apply Wiener-Hopf filter
    N = 64; % Filter order

    %APPLYING WIENER-HOPF FILTERING
    tic;
    [w, y_est] = wienerHopf(x, d, N);
    elapsed_time = toc;
    fprintf('Wiener-Hopf took: %u \n', elapsed_time);

    %Renormalizing the filtered signal in case it has peaked.
    y_est = y_est / max(abs(y_est));


    if length(y_est) ~= length(d)
        error('Signals y_est and d must be the same length');
    end

    %LISTENING THE DEMIXED AUDIO
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
    
    % ADDING SPECTROGRAMS
    % Compute spectrogram for x (blended signal)
    figure;
    subplot(2, 1, 1);
    x = x(:,1);
    spectrogram(x, 256, 250, 256, sampling_rate, 'yaxis');
    title('Spectrogram of x (Blended Signal)');
    colorbar;

    % Compute spectrogram for y_est (filtered signal)
    subplot(2, 1, 2);
    spectrogram(y_est, 256, 250, 256, sampling_rate, 'yaxis');
    title('Spectrogram of y_est (Filtered Signal)');
    colorbar;

end