function [min_d,pt1,pt2] = UAM_quad(P0,P1,Q0,Q1,del_x)
% CS6380_quad - determine closest points on two line segments
% On input:
%     P0 (1x3 vector): endpt 1 of segment 1
%     P1 (1x3 vector): endpt 2 of segment 1
%     Q0 (1x3 vector): endpt 1 of segment 2
%     Q1 (1x3 vector): endpt 2 of segment 2
%     del_x (float): spacing for discrete spacing for distance check
% On output:
%     min_d (float): minimum distance between two segment
%     pt1 (1x3 vector): closest point to segment 2 on segment 1
%     pt1 (1x3 vector): closest point to segment 1 on segment 2
% Call:
%     [min_d,pt1,pt2] = UAM_quad(P0,P1,Q0,Q1,0.001);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

vals = [0:del_x:1];
num_vals = length(vals);
dists = zeros(num_vals,num_vals);

for k1 = 1:num_vals
    s = vals(k1);
    for k2 = 1:num_vals
        t = vals(k2);
        dists(k1,k2) = UAM_seg_dist(P0,P1,Q0,Q1,s,t);
    end
end

[rows,cols] = find(min(min(dists))==dists);
if length(rows)>1
    r1 = floor(median(rows));
    c1 = floor(median(cols));
else
    r1 = rows;
    c1 = cols;
end

s = vals(r1);
t = vals(c1);
pt1 = P0 + s*(P1-P0);
pt2 = Q0 + t*(Q1-Q0);
min_d = dists(r1,c1);
