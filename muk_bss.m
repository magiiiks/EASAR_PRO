function [W, Y] = muk_bss(X, num_sources, max_iter)
    [M, N] = size(X);
    W = eye(M);
    
    for iter = 1:max_iter
        Y = W * X;
        
        for i = 1:M
            ki = kurtosis(Y(i, :));
            gi = sign(ki) * Y(i, :) * Y(i, :)' * Y(i, :) / N;
            
            for j = 1:M
                if j ~= i
                    W(i, :) = W(i, :) - (W(i, :) * W(j, :)') * W(j, :);
                end
            end
            
            W(i, :) = W(i, :) + gi;
            W(i, :) = W(i, :) / norm(W(i, :));
        end
    end
    
    Y = W * X;
end