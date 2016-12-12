function [kappa ff] = layer_remain_fit(x, y)
%% Fit function to molecules decay to determine energy barriers

cut = find(y<0.05); cutoff = min(cut); cuthalf = cutoff/2;
time = x; ln_decay = log(y);
if (isempty(cut)== false)
    time = x(1:cutoff);
    ln_decay = log(y(1:cutoff));
end
weight = ones(length(time),1);
weight(1:cuthalf) = 2;
[ff, error, out] = fit(time,ln_decay,'poly1','Weight',weight);
kappa = -ff.p1;



end