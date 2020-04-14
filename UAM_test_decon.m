function UAM_test_decon
%

traj = [1,1,0 1,1,10; 1,1,10 1,11,10; 1,11,10 1,11,0];
flight_path = [0,10,1,1; 10,20,1,2; 20,30,1,3];
for f = 1:2
    flights(f).speed = 1;
    flights(f).start_time = 0;
    flights(f).traj = traj;
    flights(f).end_time = 30;
    flights(f).flight_path = flight_path;
    flights(f).grid_els = 1;
end
n_flight = UAM_deconflict(flights(1),flights(2),0.1,1);
tch = 0;
