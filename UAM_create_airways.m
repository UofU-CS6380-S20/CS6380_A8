function airways = UAM_create_airways(vertexes,edges,launch_vertexes,...
    land_vertexes,lower_altitude,upper_altitude,r_len)
% UAM_create_airways - create lane network from ground locations
% On input:
%     vertexes (nx2 array): 2D locations on the ground (intersections)
%     edges (mx2 array): pairs of vertexes which have roads between them
%     launch_vertexes (px1 vector): indexes of launch capable vertexes
%     land_vertexes (qx1 vector): indexes of land capable vertexes
%     lower_altitude (float): lower lane altitude
%     upper_altitude (float): upper lane altitude
%     r_len (float): roundabout lane length (same for all)
% On output:
%     airways (airways struct): contains airway information
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
%      aa = UAM_create_airways(vertexes,edges,launch_vertexes,...
%         land_vertexes,10,12,r_len)
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

%UPPER_ALTITUDE = 540;
%LOWER_ALTITUDE = 470;
UPPER_ALTITUDE = upper_altitude;
LOWER_ALTITUDE = lower_altitude;

airways = [];
if isempty(vertexes)|isempty(edges)
    return
end

num_vertexes = length(vertexes(:,1));
num_edges = length(edges(:,1));
num_launch_vertexes = length(launch_vertexes);
num_land_vertexes = length(land_vertexes);

all_vertexes = [];
vertexes2D = [];   
for v = 1:num_vertexes
    indexes = find(edges(:,2)==v);
    v_vecs = edges(indexes,:);
    indexes = find(edges(:,1)==v);
    v_vecs = [v_vecs; [edges(indexes,2),edges(indexes,1)]];
    num_v_vecs = length(v_vecs(:,1));
    new_vertexes = zeros(num_v_vecs,5);
    for vn = 1:num_v_vecs
        v1 = v_vecs(vn,1);
        new_vertexes(vn,3) = v;
        new_vertexes(vn,4) = v1;
        dir = vertexes(v1,:) - vertexes(v,:);
        dir = dir/norm(dir);
        new_vertexes(vn,5) = posori(atan2(dir(2),dir(1)));
    end
    [vals,indexes] = sort(new_vertexes(:,5));
    new_vertexes = new_vertexes(indexes,:);
    if num_v_vecs==1
        dist = 2*pi/3;
        new_vertexes = [new_vertexes; 0,0,v,v,new_vertexes(1,5)+dist];
        new_vertexes = [new_vertexes; 0,0,v,v,new_vertexes(1,5)+2*dist];
    else
        s = zeros(num_v_vecs,1);
        for k = 1:num_v_vecs-1
            s(k) = abs(new_vertexes(k,5)-new_vertexes(k+1,5));
        end
        s(end) = 2*pi - sum(s(1:num_v_vecs-1));
        circle = [new_vertexes(:,5),s];
        [vals,indexes] = sort(circle(:,2),'descend');
        index1 = indexes(1);
        index2 = indexes(2);
        val1 = vals(1);
        val2 = vals(2);
        if val1>=2*val2
            dist = circle(indexes(1),2)/3;
            new_vertexes = [new_vertexes; 0,0,v,v,...
                posori(circle(indexes(1),1)+dist)];
            new_vertexes = [new_vertexes; 0,0,v,v,...
                posori(circle(indexes(1),1)+2*dist)];
        else
            dist1 = val1/2;
            dist2 = val2/2;
            new_vertexes = [new_vertexes; 0,0,v,v,...
                posori(circle(indexes(1),1)+dist1)];
            new_vertexes = [new_vertexes; 0,0,v,v,...
                posori(circle(indexes(2),1)+dist2)];
        end        
    end
    [vals,indexes] = sort(new_vertexes(:,5));
    new_vertexes = new_vertexes(indexes,:);
    radius = UAM_roundabout_lanes(new_vertexes(:,5),r_len);
    num_v_vecs = num_v_vecs + 2;
    for vn = 1:num_v_vecs
        theta = new_vertexes(vn,5);
        dir = [cos(theta),sin(theta)];
        new_vertexes(vn,1:2) = vertexes(v,:) + radius*dir;
        new_vertexes(vn,3) = v;
        new_vertexes(vn,4) = new_vertexes(vn,4);
    end
    all_vertexes = [all_vertexes;new_vertexes];
    vertexes2D = [vertexes2D; new_vertexes];
end

% Create roundabout points and lanes
lanes = [];
vertexes3D = [];
edges3D = [];
for v = 1:num_vertexes
    indexes = find(all_vertexes(:,3)==v);
    pts = all_vertexes(indexes,1:2);
    num_pts = length(indexes);
    dirs = zeros(num_pts,3);
    for p = 1:num_pts
        dir = pts(p,:) - vertexes(v,:);
        dir = dir/norm(dir);
        dirs(p,1:2) = dir;
        dirs(p,3) = posori(atan2(dir(2),dir(1)));
    end
    [vals,indexes_sorted] = sort(dirs(:,3));
    r_indexes = indexes(indexes_sorted);
    % roundabouts
    for p = 1:num_pts-1
        index1 = r_indexes(p);
        index2 = r_indexes(p+1);
        pt1 = [all_vertexes(index1,1:2),UPPER_ALTITUDE];
        pt2 = [all_vertexes(index2,1:2),UPPER_ALTITUDE];
        [vertexes3D,index3D1] = UAM_add_vertex3D(vertexes3D,pt1,...
            all_vertexes(index1,3:4));
        [vertexes3D,index3D2] = UAM_add_vertex3D(vertexes3D,pt2,...
            all_vertexes(index2,3:4));
        edges3D = [edges3D; index3D1,index3D2];
        lanes = [lanes;pt1,pt2,v,v,index3D1,index3D2];
        pt1 = [all_vertexes(index1,1:2),LOWER_ALTITUDE];
        pt2 = [all_vertexes(index2,1:2),LOWER_ALTITUDE];
        [vertexes3D,index3D1] = UAM_add_vertex3D(vertexes3D,pt1,...
            all_vertexes(index1,3:4));
        [vertexes3D,index3D2] = UAM_add_vertex3D(vertexes3D,pt2,...
            all_vertexes(index2,3:4));
        edges3D = [edges3D; index3D1,index3D2];
        lanes = [lanes;pt1,pt2,v,v,index3D1,index3D2];
    end
    pt1 = [all_vertexes(r_indexes(end),1:2),UPPER_ALTITUDE];
    pt2 = [all_vertexes(r_indexes(1),1:2),UPPER_ALTITUDE];
    [vertexes3D,index3D1] = UAM_add_vertex3D(vertexes3D,pt1,...
        all_vertexes(r_indexes(end),3:4));
    [vertexes3D,index3D2] = UAM_add_vertex3D(vertexes3D,pt2,...
        all_vertexes(r_indexes(1),3:4));
    edges3D = [edges3D; index3D1,index3D2];
    lanes = [lanes;pt1,pt2,v,v,index3D1,index3D2];
    pt1 = [all_vertexes(r_indexes(end),1:2),LOWER_ALTITUDE];
    pt2 = [all_vertexes(r_indexes(1),1:2),LOWER_ALTITUDE];
    [vertexes3D,index3D1] = UAM_add_vertex3D(vertexes3D,pt1,...
        all_vertexes(r_indexes(end),3:4));
    [vertexes3D,index3D2] = UAM_add_vertex3D(vertexes3D,pt2,...
        all_vertexes(r_indexes(1),3:4));
    edges3D = [edges3D; index3D1,index3D2];
    lanes = [lanes;pt1,pt2,v,v,index3D1,index3D2];
end

% Create between ground vertex lanes
num_vertexes3D = length(vertexes3D(:,1));
used = zeros(num_vertexes3D,1);
for v = 1:num_vertexes3D
    if used(v)==0
        v1 = vertexes3D(v,4);
        v2 = vertexes3D(v,5);
        ve = find(vertexes3D(:,4)==v2&vertexes3D(:,5)==v1...
           &vertexes3D(v,3)==vertexes3D(:,3));
       if ~isempty(ve)&v1~=v2
            pt1 = vertexes3D(v,1:3);
            pt2 = vertexes3D(ve,1:3);
            edges3D = [edges3D;v,ve];
            lanes = [lanes;pt1,pt2,v1,v2,v,ve];
            used(ve) = 1;
            v3 = find(vertexes3D(:,4)==v1&vertexes3D(:,5)==v2...
                &vertexes3D(v,3)~=vertexes3D(:,3));
            v4 = find(vertexes3D(:,4)==v2&vertexes3D(:,5)==v1...
                &vertexes3D(v3,3)==vertexes3D(:,3));
            pt3 = vertexes3D(v3,1:3);
            pt4 = vertexes3D(v4,1:3);
            edges3D = [edges3D;v4,v3];
            lanes = [lanes;pt4,pt3,v2,v1,v4,v3];
            used(v3) = 1;
            used(v4) = 1;
       end
    end
end

% Create roundabout up/down lanes
%degree_in = zeros(num_vertexes3D,1);
%degree_out = degree_in;
%for v = 1:num_vertexes3D
%    degree_in(v) = length(find(edges3D(:,2)==v));
%    degree_out(v) = length(find(edges3D(:,1)==v));
%end
for v = 1:num_vertexes
    indexes = find(vertexes3D(:,4)==v&vertexes3D(:,5)==v);
    index1 = indexes(1);
    x1 = vertexes3D(index1,1);
    y1 = vertexes3D(index1,2);
    z1 = vertexes3D(index1,3);
    index2 = find(vertexes3D(:,1)==x1&vertexes3D(:,2)==y1...
        &vertexes3D(:,3)~=z1);
    lane1 = [vertexes3D(index1,1:3),vertexes3D(index2,1:3),...
        vertexes3D(index1,4),vertexes3D(index1,4),index1,index2];
    lanes = [lanes; lane1];
    index = find(indexes==index2);
    indexes = setdiff(indexes,index1);
    indexes = setdiff(indexes,index2);
    index1 = indexes(1);
    index2 = indexes(2);
    if vertexes3D(index1,3)==lane1(3)
        index = index1;
        index1 = index2;
        index2 = index;
    end
    x1 = vertexes3D(index1,1);
    y1 = vertexes3D(index1,2);
    z1 = vertexes3D(index1,3);
    x2 = vertexes3D(index2,1);
    y2 = vertexes3D(index2,2);
    z2 = vertexes3D(index2,3);
    lane2 = [x1,y1,z1,x2,y2,z2,...
        vertexes3D(index1,4),vertexes3D(index1,4),index1,index2];
    lanes = [lanes; lane2];
end

% Create launch vertexes
for ind = 1:num_launch_vertexes
    v = launch_vertexes(ind);
    indexes = find(vertexes3D(:,4)==v&vertexes3D(:,5)==v...
        &vertexes3D(:,3)==LOWER_ALTITUDE);
    index1 = indexes(1);
    index2 = indexes(2);
    x1 = vertexes3D(index1,1);
    y1 = vertexes3D(index1,2);
    z1 = vertexes3D(index1,3);
    pt1 = [x1,y1,0];
    vertexes3D = [vertexes3D; pt1,v,v];
    x2 = vertexes3D(index2,1);
    y2 = vertexes3D(index2,2);
    z2 = vertexes3D(index2,3);
    pt2 = [x2,y2,0];
    vertexes3D = [vertexes3D; pt2,v,v];
    num_vertexes3D = length(vertexes3D(:,1));
    lane1 = [pt1,vertexes3D(index1,1:3),v,v,num_vertexes3D-1,index1];
    lane2 = [vertexes3D(index2,1:3),pt2,v,v,index2,num_vertexes3D];
    lanes = [lanes; lane1];
end
for ind = 1:num_land_vertexes
    v = land_vertexes(ind);
    indexes = find(vertexes3D(:,4)==v&vertexes3D(:,5)==v...
        &vertexes3D(:,3)==LOWER_ALTITUDE);
    index1 = indexes(1);
    index2 = indexes(2);
    x1 = vertexes3D(index1,1);
    y1 = vertexes3D(index1,2);
    z1 = vertexes3D(index1,3);
    pt1 = [x1,y1,0];
    vertexes3D = [vertexes3D; pt1,v,v];
    x2 = vertexes3D(index2,1);
    y2 = vertexes3D(index2,2);
    z2 = vertexes3D(index2,3);
    pt2 = [x2,y2,0];
    vertexes3D = [vertexes3D; pt2,v,v];
    num_vertexes3D = length(vertexes3D(:,1));
    lane1 = [pt1,vertexes3D(index1,1:3),v,v,num_vertexes3D-1,index1];
    lane2 = [vertexes3D(index2,1:3),pt2,v,v,index2,num_vertexes3D];
    lanes = [lanes; lane2];
end

launch_indexes = find(lanes(:,3)==0)'; % launch lanes
land_indexes = find(lanes(:,6)==0)'; % land lanes

airways.vertexes = vertexes;
airways.edges = edges;
airways.r_len = r_len;
airways.ground_launch_vertexes = launch_vertexes;
airways.ground_land_vertexes = land_vertexes;
airways.launch_lane_indexes = launch_indexes;
airways.land_lane_indexes = land_indexes;
airways.vertexes3D = vertexes3D;
airways.lanes = lanes;
airways.lane_lengths = UAM_lane_lengths(airways);

tch = 0;
