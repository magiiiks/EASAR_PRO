function [S, A, W] = fastica(X, n_components)
    [n_samples, n_features] = size(X);
    
    % Centering
    X = X - mean(X, 1);
    
    % Whitening
    [E, D] = eig(cov(X));
    D = diag(D);
    W_white = diag(1./sqrt(D)) * E';
    X_white = X * W_white';
    
    % FastICA
    W = randn(n_components, n_features);
    W = W ./ vecnorm(W, 2, 2);
    
    for i = 1:100
        W_old = W;
        for j = 1:n_components
            w = W(j, :);
            w = X_white' * (X_white * w').^3 / n_samples - 3 * w;
            w = w - W' * W * w;
            w = w / norm(w);
            W(j, :) = w;
        end
        if norm(abs(W * W_old') - eye(n_components)) < 1e-4
            break;
        end
    end
    
    S = X_white * W';
    A = W_white' * pinv(W);
end
