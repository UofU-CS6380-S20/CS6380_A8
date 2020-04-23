function n_c = UAM_num_intervals(d)
%

n = length(d);

n_c = sum(d);
for k1 = 1:n-1
    for k2 = k1+1:n
        n_c = n_c + d(k1)*d(k2);
    end
end
