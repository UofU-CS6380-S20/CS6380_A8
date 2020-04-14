function edges = UAM_lane_edges(airways)
% UAM_lane_edges - get edges between lanes
% On output:
%     airways (airways struct): airways
% On output:
%     edges (ex2 array): edges between lanes
% Call:
%     e = UAM_lane_edges(aa);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

lanes = airways.lanes;
num_lanes = length(lanes(:,1));
edges = [];
for p = 1:num_lanes
    pt = lanes(p,4:6);
    indexes = find(lanes(:,1)==pt(1)&lanes(:,2)==pt(2)&lanes(:,3)==pt(3));
    if ~isempty(indexes)
        num_indexes = length(indexes);
        edges = [edges; [p*ones(num_indexes,1),indexes]];
    end
end
