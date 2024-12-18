function [separated_signals, prediction_coeffs] = levinsonDurbinBss(mixed_signals, order)
    % Step 1: Perform Blind Source Separation
    [separated_signals, ~] = blindSourceSeparation(mixed_signals);
    
    % Step 2: Apply Levinson-Durbin to each separated signal
    num_sources = size(separated_signals, 1);
    prediction_coeffs = cell(num_sources, 1);
    
    for i = 1:num_sources
        % Compute autocorrelation
        r = xcorr(separated_signals(i, :), order, 'biased');
        r = r(order+1:end);
        
        % Apply Levinson-Durbin
        [a, ~] = levinsonDurbin(r, order);
        prediction_coeffs{i} = a;
    end
end