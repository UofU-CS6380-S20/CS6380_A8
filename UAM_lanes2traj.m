function traj = UAM_lanes2traj(airway,lanes)
%

traj = [];

if isempty(lanes)
    return
end

num_lanes = length(lanes);
traj = zeros(num_lanes,6);
for k = 1:num_lanes
    traj(k,:) = airway.lanes(lanes(k),1:6);
end
