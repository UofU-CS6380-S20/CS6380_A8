function weights = UAM_lane_weights(airways)
%

lanes = airways.lanes;
num_lanes = length(lanes(:,1));
weights = zeros(num_lanes,1);
for p = 1:num_lanes
    pt1 = lanes(p,1:3);
    pt2 = lanes(p,4:6);
    weights(p) = norm(pt2-pt1);
end
