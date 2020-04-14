function res = UAM_intersect_intervals(int1,int2)
%

res = [];

if isempty(int1)|isempty(int2)
    return
end

i11 = int1(1);
i12 = int1(2);
i21 = int2(1);
i22 = int2(2);

if i12<i21|i22<i11
    return
end

if i11>=i21&i12<=i22
    res = int1;
elseif i21>=i11&i22<i12
    res = int2;
elseif i11<=i21&i21<=i22
    res = [i21,i12];
elseif i21<=i11&i22<=i12
    res = [i11,i22];
end
