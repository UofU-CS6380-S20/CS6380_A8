function d = UAM_seg_dist(P0,P1,Q0,Q1,s,t)
% UAM_seg_dist - distance between points on segments that are s and t
%    percent of the way along each segment, respectively
% On input:
%     P0 (1x3 vector): segment 1 endpoint 1
%     P1 (1x3 vector): segment 1 endpoint 2
%     Q0 (1x3 vector): segment 2 endpoint 1
%     Q1 (1x3 vector): segment 2 endpoint 2
%     s (float in [0,1]): percentage across segment 1
%     t (float in [0,1]): percentage across segment 2
% On output:
%     d (float): distance between 2 segment points
% Call:
%     dists(k1,k2) = UAM_seg_dist(P0,P1,Q0,Q1,s,t);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

w = P0 - Q0 + s*(P1-P0) - t*(Q1-Q0);
d = sqrt(dot(w,w));
