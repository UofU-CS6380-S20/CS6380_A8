function radius = UAM_roundabout_lanes(angles,r_len)
% UAM_roundabout_lanes - determine radius to have r_len roundabout sides
% On input:
%     angles (nx1 vector): angles of directions of lanes connecting to
%       other ground vertexes
%     r_len (float): minimum length of roundabout lanes
% On output:
%     radius (float): radius of circle for roundabout points
% Call:
%     r = UAM_roundabout_lanes(a,len);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

radius = r_len;
num_lanes = length(angles);
if num_lanes<2
    return
end
theta_tween = zeros(num_lanes-1,1);
for t = 1:num_lanes-1
    dir1 = [cos(angles(t));sin(angles(t))];
    dir2 = [cos(angles(t+1));sin(angles(t+1))];
    theta_tween(t) = posori(acos(dot(dir1,dir2)));
end
theta_min = min(theta_tween);
radius = (r_len/2)/sin(theta_min/2);
