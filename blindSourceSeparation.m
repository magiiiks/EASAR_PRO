function [S, W] = blindSourceSeparation(X)
    % X: mixed signals (each column is a signal)
    
    % Center the data
    X = X - mean(X, 2);
    
    % Whiten the data
    [E, D] = eig(cov(X'));
    X_white = E * diag(1./sqrt(diag(D))) * E' * X;
    
    % Apply fixed-point algorithm for ICA
    [W, ~] = fpica(X_white);
    
    % Compute separated sources
    S = W' * X_white;
end

function [W, Y] = fpica(X, max_iter)
    if nargin < 2
        max_iter = 100;
    end
    
    [n, ~] = size(X);
    W = orth(randn(n, n));
    
    for i = 1:max_iter
        Y = W' * X;
        G = tanh(Y);
        Gp = 1 - tanh(Y).^2;
        W_new = (X * G' / size(X, 2) - diag(mean(Gp, 2)) * W) / n;
        W_new = W_new * (W_new' * W_new)^(-0.5);
        
        if norm(abs(diag(W_new' * W)) - ones(n, 1)) < 1e-6
            break;
        end
        W = W_new;
    end
    Y = W' * X;
end
