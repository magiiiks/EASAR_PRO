function [a, e] = levinsonDurbin(r, p)
    a = zeros(p, 1);
    e = r(1);
    for i = 1:p
        if i == 1
            k = r(2) / e;
        else
            k = (r(i+1) - a(1:i-1)' .* r(i:-1:2)) / e
        end
        la = length(a(i))
        lk = length(k)
        a(i) = k;
        if i > 1
            a(1:i-1) = a(1:i-1) - k .* a(i-1:-1:1);
        end
        e = (1 - k^2) * e;
    end
    a = [-a; 1];
    a = flipud(a);
end