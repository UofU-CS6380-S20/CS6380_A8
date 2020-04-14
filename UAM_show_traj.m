function UAM_show_traj(traj,col)
% CS6380_show_traj - plot 3D trajectory
% On input:
%     traj (nx6 array): n 3D line segements (xi1,yi1,zi1,xi2,yi2,zi2)
%     col (string): color and symbol (if any; e.g., 'r*') for plot
% On output:
%     N/A
% Call:
%     UAM_show_traj(traj,'r*');
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

hold on
len_traj = length(traj(:,1));
for t = 1:len_traj
    plot3([traj(t,1),traj(t,4)],[traj(t,2),traj(t,5)],...
        [traj(t,3),traj(t,6)],col);
end
