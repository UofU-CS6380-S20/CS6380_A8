function [flights,dc] = UAM_test_reserve2(num_flights)
%

aa = UAM_create_airway_demo;
lanes = UAM_flight_path(aa,1,25);
t1 = 0;
t2 = 60;
speed = 1;
h_t = 2;

dc = 0;
flights = [];
for f = 1:num_flights
    [fp,dc1,flights] = UAM_reserve_flight(aa,flights,t1,t2,speed,lanes,2);
    [f,dc1]
    dc = dc + dc1;
end
tch = 0;
