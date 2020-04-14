function UAM_test_reserve1
%

pts(1,:) = [5,5,0];
pts(2,:) = [5,5,10];
pts(3,:) = [5,15,10];
pts(4,:) = [5,15,0];
vertexes = pts(1:2:end,1:2);
edges = [1,2];
launch_vertex = 1;
land_vertex = 2;
r_len = 1;

airway = UAM_create_airways(vertexes,edges,launch_vertex,land_vertex,r_len);
lanes = UAM_flight_path(airway,1,2);
lane_lengths = UAM_lane_lengths(airway);
min_t = 0;
max_t = 60;
speed = 1;
h_t = 1;

[fp,dc] = UAM_reserve_flight(airway,min_t,max_t,speed,lanes,...
    lane_lengths,h_t);

s_flights(1).speed = 1;
s_flights(1).start_time = 0;
s_flights(1).traj = [1,1,0, 1,1,10; 1,1,10, 1,11,10; 1,11,10, 1,11,0];
s_flights(1).flight_path = [0,10,1,1; 10,20,1,2; 20,30,1,3];
s_flights(1).end_time = 30;
s_flights(1).grid_els = 1;
s_flights(1).d_count = 0;
n_flight = s_flights(1);
nf = UAM_deconflict(s_flights(1),n_flight,0.1,1);
s_flights(2) = nf;
nf = UAM_deconflict(s_flights(1:2),n_flight,0.1,1);
