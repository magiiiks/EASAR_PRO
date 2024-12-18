function [w, y_est] = wienerHopf(x, d, N)
    % x: input signal
    % d: desired signal
    % N: filter order
    
    L = length(x); % Length of the input signal
    
    % Compute autocorrelation matrix R
    R = zeros(N, N);
    for i = 1:N
        for j = 1:N
            R(i,j) = mean(x(1:L-max(i,j)+1) .* x(max(i,j):L));
        end
    end
    
    % Compute cross-correlation vector p
    p = zeros(N, 1);
    for i = 1:N
        p(i) = mean(d(i:L) .* x(1:L-i+1));
    end
    
    % Solve Wiener-Hopf equation
    w = R \ p;
    
    % Apply filter to input signal
    y_est = filter(w, 1, x);
end
