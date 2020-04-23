function [res,du,db] = UAM_complexity(num_trials)
%

f = 20;
n = 10;

res = 0;

d = 2*ones(1,10);
du = UAM_num_intervals(d);
for t = 1:num_trials
    d = zeros(1,n);
    x = f;
    for k = 1:n-1
        r = rand;
        d(k) = floor(x*r);
        x = x - d(k);
    end
    d(end) = f - sum(d);
    v = UAM_num_intervals(d);
    if v>res
        db = d;
        res = v;
    end
end
