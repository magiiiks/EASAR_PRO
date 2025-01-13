function a = levinsonDurbin(r)
    L = length(r)-1;   % Order of the Filter 
    a = zeros(L+1,1);  % initialize filter coefficient vector
    kappa = r(2);      % initial kappa
    MSE   = r(1);      % Mean Squared Error r[0]
    K     = -kappa/MSE;    
    MSE   = MSE+kappa*K;
    a(1)  = K;

    for ll = 2:L
        kappa = r(2:ll)'*flipud(a(1:ll-1)) + r(ll+1);
        K = -kappa/MSE;
        a(1:ll) = [a(1:ll-1) ; 0]  +  K*[flipud(a(1:ll-1)) ; 1];    
        MSE = MSE + kappa*K;
    end

    a(2:L+1) = a(1:L); 
    a(1) = 1;
end

