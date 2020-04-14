function UAM_show_airways(airways)
% UAM_show_airways - 3D plot (red: land; green: launch; else: black)
% On input:
%     airways (airways struct): airways info
% On output:
%     3D plot
% Call:
%     UAM_show_airways(aa3x3);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

lanes = airways.lanes;
num_lanes = length(lanes(:,1));

clf
hold on
view(-20,15);
for p = 1:num_lanes
    plot3([lanes(p,1),lanes(p,4)],[lanes(p,2),lanes(p,5)],[lanes(p,3),...
        lanes(p,6)],'k');
end
launch_indexes = find(lanes(:,3)==0);
land_indexes = find(lanes(:,6)==0);
for ind = 1:length(launch_indexes)
    p = launch_indexes(ind);
    plot3([lanes(p,1),lanes(p,4)],[lanes(p,2),lanes(p,5)],[lanes(p,3),...
        lanes(p,6)],'g');
end
for ind = 1:length(land_indexes)
    p = land_indexes(ind);
    plot3([lanes(p,1),lanes(p,4)],[lanes(p,2),lanes(p,5)],[lanes(p,3),...
        lanes(p,6)],'r');
end
