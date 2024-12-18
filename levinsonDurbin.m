function [a, e] = levinsonDurbin(r, p)
    % r: autocorrelation sequence
    % p: order of the linear prediction filter
    
    a = zeros(p, 1);
    e = r(1);
    
    for i = 1:p
        k = (r(i+1) - a(1:i-1)' * r(i:-1:2)) / e;
        a(i) = k;
        a(1:i-1) = a(1:i-1) - k * a(i-1:-1:1);
        e = (1 - k^2) * e;
    end
    
    a = [1; -a];
end