function [airways,lane_flights,flights,flights_FN] = ...
    UAM_FNSD_LSD_scenario3(min_start0,max_start0,min_speed,max_speed,...
    num_flights,del_t,h_t)
% UAM_FNSD_LSD_scenario3 - compare FAA-NASA SD with Lane SD
% On input:
%     min_start (float): earliest start time
%     max_start (float): latest start time
%     min_speed (float): minimum speed (0.1 corresponds to 3mph)
%     max_speed (float): maximum speed (0.31 corresponds to 10 mph)
%     num_flights (int): number of flights to schedule
%     del_t (float): time step for simulated motion
%     h_t (float): minimum headway time
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
%     lane_flights (lane flight data structure): lane-based flight data
%       .flights (kx5 vector): time in,time out,speed,lane,ID
%     flights (flight struct) per flight info
%       (k).start_time (float): start time of flight
%       (k).end_time (float): end time of flight
%       (k).lanes
%       (k).speed)
%     flights_FN (flight struct): FAA-NASA flight data
%       (k).start_time (float): start time of flight
%       (k).end_time (float): end time of flight
%       (k).lanes
%       (k).speed)
% Call:
%     [aa,ff,ffFN] = UAM_FNSD_LSD_scenario3(0,60,0.1,0.31,100,0.1,1);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

LOWER_ALTITUDE = 10;
UPPER_ALTITUDE = 12;
M = 100;
N = 100;
MAX_START_INTERVAL = 100;

grid_x = 20;

h_x = max_speed*h_t;

airways = UAM_create_airway_demo_diags;
num_ground_vertexes = length(airways.vertexes(:,1));

display('Create flights');
wb = waitbar(0,'Flights');
lane_flights = [];
flights = [];
for f = 1:num_flights
    waitbar(f/num_flights);
    launch_index = randi(num_ground_vertexes);
    land_index = randi(num_ground_vertexes);
%    launch_index = 1;
%    land_index = 36;
    speed = min_speed+rand*(max_speed-min_speed);
%    speed = 0.12;
    min_start = min_start0 + rand*(max_start0-min_start0);
    max_start = min_start + rand*MAX_START_INTERVAL;
    lanes = UAM_flight_path(airways,launch_index,land_index);
    flights(f).length = sum(airways.lane_lengths(lanes));
    tic;
    [flight_path,d_count,lane_flights] = UAM_reserve_flight(airways,...
        lane_flights,min_start,max_start,speed,lanes,f,h_t);
    flights(f).d_time = toc;
    if ~isempty(flight_path)
        flights(f).lanes = lanes;
        flights(f).start_interval = [min_start,max_start];
        flights(f).flight_path = flight_path;
        flights(f).d_count = d_count;
        flights(f).start_time = flight_path(1,1);
        flights(f).end_time = flight_path(end,2);
    else
        flights(f).lanes = lanes;
        flights(f).flight_path = flight_path;
        flights(f).d_count = d_count;
        flights(f).start_time = -1;
        flights(f).end_time = -1;
    end
end
close(wb);

lanes = airways.lanes;
grid.x_min = min([airways.lanes(:,1);airways.lanes(:,4)])-10;
grid.x_max = max([airways.lanes(:,1);airways.lanes(:,4)])+10;
grid.y_min = min([airways.lanes(:,2);airways.lanes(:,5)])-10;
grid.y_max = max([airways.lanes(:,2);airways.lanes(:,5)])+10;
grid.del_x = 20;
grid.del_y = 20;
wb = waitbar(0,'Create FN Flights');
for f = 1:num_flights
    waitbar(f/num_flights);
    if flights(f).start_time>=0
        flights_FN(f).speed = flights(f).flight_path(1,3);
        flights_FN(f).start_time = min_start;
        flights_FN(f).start_interval = flights(f).start_interval;
        launch_lane = flights(f).flight_path(1,4);
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
        flights_FN(f).grid_count = 0;
        flights_FN(f).pinch_count = 0;
        flights_FN(f).space_count = 0;
        flights_FN(f).time_count = 0;
        flights_FN(f).d_time = 0;
        flights_FN(f).end_time = flights(f).start_time...
            + total_len/flights_FN(f).speed;
        flights_FN(f).grid_els = UAM_grid_els(grid,traj(1,1:3),...
            traj(end,4:6),M,N);
    end
end
close(wb);
num_flights_FN = length(flights_FN);
s_flights = [];
wb = waitbar(0,'FN Deconflict');
%for f = 1:num_flights_FN
wt_val = 0;
f = 0;
while wt_val<10
    f = f + 1;
    waitbar(f/num_flights);
    if ~isempty(flights_FN(f).traj)
        n_flight = flights_FN(f);
        tic;
        n_flight = UAM_deconflict(s_flights,n_flight,del_t,h_t);
        n_flight.d_time = toc;
        wt_val = n_flight.d_time;
        flights_FN(f) = n_flight;
        s_flights = flights_FN(1:f);
    end
end
close(wb);

tch = 0;
