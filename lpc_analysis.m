function [residual, lpc_coeffs] = lpc_analysis(signal, order, frame_size, overlap)
    num_frames = floor((length(signal) - overlap) / (frame_size - overlap));
    residual = zeros(size(signal));
    lpc_coeffs = zeros(order+1, num_frames);
    
    for i = 1:num_frames
        start_idx = (i-1)*(frame_size-overlap) + 1;
        end_idx = start_idx + frame_size - 1;
        frame = signal(start_idx:end_idx) .* hamming(frame_size);
        
        r = xcorr(frame, order);
        r = r(order+1:end);
        
        [a, ~] = levinsonDurbin(r, order);
        lpc_coeffs(:, i) = a;
        
        residual(start_idx:end_idx) = filter(a, 1, frame);
    end
end

function w = hamming(N)
    n = 0:N-1;
    w = 0.54 - 0.46 * cos(2*pi*n/(N-1));
end