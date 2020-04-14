function [airways,flights,flights_FN] = UAM_FNSD_LSD_scenario1(...
    min_start,max_start,min_speed,max_speed,num_flights,del_t,h_t,grid_x,...
    per_launch,per_land)
% UAM_FNSD_LSD_scenario - compare FAA-NASA SD with Lane SD
% On input:
%     min_start (float): earliest start time
%     max_start (float): latest start time
%     min_speed (float): minimum speed (0.1 corresponds to 3mph)
%     max_speed (float): maximum speed (0.31 corresponds to 10 mph)
%     num_flights (int): number of flights to schedule
%     del_t (float): time step for simulated motion
%     h_t (float): minimum headway time
%     grid_x (float): spacing on grid element side
%     per_launch (float): percent launch sites (wrt ground vertexes)
%     per_land (float); percent land sites (wrt ground vertexes)
% On output:
%     airways (airway data structure): airways info
%       .vertexes (nx2 array): x,y locations of road intersections
%       .edges (ex2 array): edges on roads (i.e., between intersections)
%       .r_len (float): minimum lane length in roundabout
%       .launch_vertexes (1xk vector): indexes of launch vertexes (ground)
%       .land_vertexes (1xm vector): indexes of land vertexes (ground)
%       .vertexes3D (px3 array): 3D lane vertexes
%       .lanes (qx10 array): x1,y1,z1,x2,y2,z2,v1_g,v2_g,v1_3D,v2_3D
%       .lane_lengths (qx1 vector): lengths of lanes
%     flights (flight data structure): lane-based flight data
%       .values (1x5 vector): time in,time out,launch v,land v,speed
%       .lanes (1xk vector): lane indexes for flight path
%       .flight_path (kx4 array): time in,time out, speed, lane index
%       .start_time (float): flight launch time
%       .end_time (float): flight land time
%     flights_FN (flight data structure): FAA-NASA flight data
%       .values (1x5 vector): time in,time out,launch v,land v,speed
%       .lanes (1xk vector): lane indexes for flight path
%       .flight_path (kx4 array): time in,time out, speed, lane index
%       .start_time (float): flight launch time
%       .end_time (float): flight land time
%       .speed (float): speed in lanes (all the same)
%       .traj (3x6 array): [pt1,pt2; pt2,pt3; pt3,p4]
% Call:
%     [aa,ff,ff] = UAM_FNSD_LSD_scenario(0,60,0.1,0.31,100,0.1,1,20,1,1);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

UPPER_ALTITUDE = 12;
LOWER_ALTITUDE = 10;
M = 100;
N = 100;

h_x = max_speed*h_t;
vals = [2:10:M];
num_vals = length(vals);
vertexes = zeros(num_vals^2,2);
edges = [];
count = 0;

display('Create vertexes');
for ind1 = 1:num_vals
    x = vals(ind1);
    for ind2 = 1:num_vals
        y = vals(ind2);
        count = count + 1;
        vertexes(count,:) = [x,y];
    end
end
num_vertexes = count;

display('Create edges');
for ind1 = 1:num_vertexes-1
    for ind2 = ind1+1:num_vertexes
        if norm(vertexes(ind1,:)-vertexes(ind2,:))==10
            edges = [edges;ind1,ind2];
        end
    end
end

% Create launch/land vertexes
launch_perm = randperm(num_vertexes);
num_launch_vertexes = max(1,floor(per_launch*num_vertexes));
land_perm = randperm(num_vertexes);
num_land_vertexes = max(1,floor(per_land*num_vertexes));
launch = unique(launch_perm(1:num_launch_vertexes));
land = unique(land_perm(1:num_land_vertexes));
r_len = 2;

display('Create airways');
airways = UAM_create_airways(vertexes,edges,launch,land,LOWER_ALTITUDE,...
    UPPER_ALTITUDE,r_len);
lane_lengths = UAM_lane_weights(airways);

display('Create flights');
wb = waitbar(0,'Flights');
flights = [];
for f = 1:num_flights
    f
    waitbar(f/num_flights);
    values = [min_start,max_start,randi(num_launch_vertexes),...
        randi(num_land_vertexes),min_speed+rand*(max_speed-min_speed)];
    lanes = UAM_flight_path(airways,values(3),values(4));
    [flight_path,d_count,flights] = UAM_reserve_flight(airways,flights,...
        values(1),values(2),values(5),lanes,f,h_t);
    if ~isempty(flight_path)
        flights(f).values = values;
        flights(f).lanes = lanes;
        flights(f).flight_path = flight_path;
        flights(f).d_count = d_count;
        flights(f).start_time = flight_path(1,1);
        flights(f).end_time = flight_path(end,2);
    else
        flights(f).values = values;
        flights(f).lanes = lanes;
        flights(f).flight_path = flight_path;
        flights(f).d_count = d_count;
        flights(f).start_time = -1;
        flights(f).end_time = -1;
    end
end
close(wb);

lanes = airways.lanes;
x_min = min([lanes(:,1);lanes(:,4)]);
x_max = max([lanes(:,1);lanes(:,4)]);
y_min = min([lanes(:,2);lanes(:,5)]);
y_max = max([lanes(:,2);lanes(:,5)]);
wb = waitbar(0,'Create FN Flights');
for f = 1:num_flights
    waitbar(f/num_flights);
    if flights(f).start_time>=0
        flights_FN(f).speed = flights(f).values(5);
        flights_FN(f).start_time = flights(f).start_time;
        launch_lane = flights(f).flight_path(1,4);;
        land_lane = flights(f).flight_path(end,4);
        launch_pt = lanes(launch_lane,1:3);
        land_pt = lanes(land_lane,4:6);
        altitude = LOWER_ALTITUDE + rand*(UPPER_ALTITUDE-LOWER_ALTITUDE);
        pt1 = launch_pt;
        pt4 = land_pt;
        pt2 = [pt1(1:2),altitude];
        pt3 = [pt4(1:2),altitude];
        traj = [pt1,pt2; pt2,pt3; pt3,pt4];
        flights_FN(f).traj = traj;
        len1 = norm(traj(1,4:6)-traj(1,1:3));
        len2 = norm(traj(2,4:6)-traj(2,1:3));
        len3 = norm(traj(3,4:6)-traj(3,1:3));
        total_len = len1 + len2 + len3;
        flight_path = zeros(3,4);
        flight_path(1,1) = flights_FN(f).start_time;
        flight_path(1,2) = flight_path(1,1) + len1/flights_FN(f).speed;
        flight_path(1,3) = flights_FN(f).speed;
        flight_path(1,4) = 1;
        flight_path(2,1) = flight_path(1,2);
        flight_path(2,2) = flight_path(2,1) + len2/flights_FN(f).speed;
        flight_path(2,3) = flights_FN(f).speed;
        flight_path(2,4) = 2;
        flight_path(3,1) = flight_path(2,2);
        flight_path(3,2) = flight_path(3,1) + len3/flights_FN(f).speed;
        flight_path(3,3) = flights_FN(f).speed;
        flight_path(3,4) = 3;
        flights_FN(f).flight_path = flight_path;
        flights_FN(f).d_count = 0;
        flights_FN(f).end_time = flights(f).start_time...
            + total_len/flights_FN(f).speed;
        flights_FN(f).grid_els = UAM_grid_els(traj(1,1:3),traj(end,4:6),...
            x_min,y_min,x_max,y_max,grid_x,M,N);
    end
end
close(wb);
num_flights_FN = length(flights_FN);
s_flights = [];
wb = waitbar(0,'FN Deconflict');
for f = 1:num_flights_FN
    waitbar(f/num_flights);
    if ~isempty(flights_FN(f).traj)
        n_flight = flights_FN(f);
        n_flight = UAM_deconflict(s_flights,n_flight,del_t,h_t);
        flights_FN(f) = n_flight;
        s_flights = flights_FN(1:f);
    end
end
close(wb);

tch = 0;
