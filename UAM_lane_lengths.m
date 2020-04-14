function lengths = UAM_lane_lengths(airways)
% UAM_lane_lengths - compute lengths of lanes
% On input:
%     airways (airway struct): airways
% On output:
%     length(1xn vector): lengths of the n lanes in airways
% Call:
%     ll = UAM)lane_lengths(airways);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

lanes = airways.lanes;
num_lanes = length(lanes(:,1));
lengths = zeros(num_lanes,1);
for p = 1:num_lanes
    pt1 = lanes(p,1:3);
    pt2 = lanes(p,4:6);
    lengths(p) = norm(pt2-pt1);
end
