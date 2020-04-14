function airway = UAM_create_airway_demo
% UAM_create_airway_demo - demonstrate how to create an airway
% On input:
%     N/A
% On output:
%     airway (airways struct): contains airway information
%       .vertexes (nx2 array): input array ground vertexes
%       .edges (mx2 array): input array ground edges (roads)
%       .launch_vertexes (px1 vector): input vector launch_vertexes
%       .land_vertexes (qx1 vector): input vector vertexes
%       .launch_lane_indexes (rx1 vector): launch lane indexes
%       .land_lane_indexes (sx1 vector): land lane indexes
%       .r_len (float): input r_len
%       .vertexes3D (dx5 array): 3D vertexes created for lanes
%         col 1: x coord
%         col 2: y coord
%         col 3: z coord
%         col 4: originating vertex from ground vertexes
%         col 5: motivating vertex from ground vertexes (if same as col 4,
%                then roundabout vertex (includes up/down between
%                roundabouts
%       .lanes (hx10 array): lane info (lanes are directed one-way)
%          col  1: x1 coord
%          col  2: y1 coord
%          col  3: z1 coord
%          col  4: x2 coord
%          col  5: y2 coord
%          col  6: z2 coord
%          col  7: originating ground vertex
%          col  8: motivating ground vertex
%          col  9: head vertex index (in vertexes3D)
%          col 10: tail vertex index (in vertexes3D)
% Call:
%     UAM_create_airway_demo
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

% create a 5x5 airway

% create ground vertexes
del_x = 10;
x_vals = [10:del_x:50];
y_vals = x_vals;
num_vals = length(x_vals);
vertexes = zeros(num_vals^2,2);
count = 0;
for indx = 1:num_vals
    x = x_vals(indx);
    for indy = 1:num_vals
        y = y_vals(indy);
        count = count + 1;
        vertexes(count,:) = [x,y];
    end
end
num_vertexes = length(vertexes(:,1));

% create edges between vertexes (i.e., roads)
edges = [];
for v1 = 1:num_vertexes-1
    pt1 = vertexes(v1,:);
    for v2 = v1+1:num_vertexes
        pt2 = vertexes(v2,:);
        if norm(pt1-pt2)<del_x+1
            edges = [edges;v1,v2];
        end
    end
end

% specify ground launch and land locations
launch_vertexes = [1:num_vertexes];
land_vertexes = [1:num_vertexes];

% specify altitudes for lower and upper lanes
%   upper lanes go one-way in directions [0,pi)
%   lower lanes go one-way in directions [pi,2pi)
lower_altitude = 10;
upper_altitude = 12;

% specify minimum length for lane in a roundabout
r_len = 2;

airway = UAM_create_airways(vertexes,edges,launch_vertexes,...
    land_vertexes,lower_altitude,upper_altitude,r_len);
