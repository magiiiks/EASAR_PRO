function reconstructed = lpc_synthesis(residual, lpc_coeffs, frame_size, overlap)
    num_frames = size(lpc_coeffs, 2);
    reconstructed = zeros(size(residual));
    
    for i = 1:num_frames
        start_idx = (i-1)*(frame_size-overlap) + 1;
        end_idx = start_idx + frame_size - 1;
        frame_residual = residual(start_idx:end_idx);
        
        frame_reconstructed = filter(1, lpc_coeffs(:, i), frame_residual);
        reconstructed(start_idx:end_idx) = reconstructed(start_idx:end_idx) + frame_reconstructed;
    end
end