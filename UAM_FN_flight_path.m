function flight_path = UAM_FN_flight_path(flight)
%

flight_path = zeros(3,4);
traj = flight.traj;
speed = flight.speed;
start_time = flight.start_time;

flight_path(:,3) = speed;
flight_path(:,4) = [1:3]';
d1 = norm(traj(1,1:3)-traj(1,4:6));
d2 = norm(traj(2,1:3)-traj(2,4:6));
d3 = norm(traj(3,1:3)-traj(3,4:6));
flight_path(1,1) = start_time;
flight_path(1,2) = start_time + d1/speed;
flight_path(2,1) = flight_path(1,2);
flight_path(2,2) = flight_path(2,1) + d2/speed;
flight_path(3,1) = flight_path(2,2);
flight_path(3,2) = flight_path(3,1) + d3/speed;
