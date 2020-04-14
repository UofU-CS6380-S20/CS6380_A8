function new_int = UR_merge_intervals(int1,int2)
% UR_merge_intervals - given two sets of intervals, merge them
% On input:
%     int1 (n1x2 array): first set of intervals
%     int2 (n2x2 array): second set of intervals
% On output:
%     new_int (px2 array): intersection of two interval sets
% Call:
%     new_int = UR_merge_intervals (int1,int2);
% Author:
%     T. Henderson
%     UU
%     Summer 2019
%

if isempty(int1)&isempty(int2)
    new_int = [];
    return
end

new_int = [int1;int2];
[vals,indexes] = sort(new_int(:,1));
new_int = new_int(indexes,:);
change = 1;
while change==1
    change = 0;
    len_new_int = length(new_int(:,1));
    for k = 1:len_new_int-1
        if new_int(k,1)==new_int(k+1,1)
            v_min = min(new_int(k,2),new_int(k+1,2));
            new_int(k+1,2) = v_min;
            new_int(k,:) = [];
            change = 1;
            break
        end
    end
end

