function [flights,fp1,fp2,fp3] = UAM_test_reserve
% UAM_test_reserve - tests the flight reservation system
% On input:
%     N/A
% On output:
%     flights (flights struct): gives flight info per lane
%       (k).flights (n_k by 5 array): n_k flights (one per row)
%          col 1: lane entry time
%          col 2: lane exit time
%          col 3: flight speed in lane
%          col 4: lane number (should match k)
%          col 5: flight id
%     fp1 (qx5 array): flight path info for flight 1
%       col 1: entry time in lane
%       col 2: exit time from lane
%       col 3: speed in lane
%       col 4: lane number
%       col 5: flight id
% Call:
%     [ff,f1,f2,f3] = UAM_test_reserve;
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

airway = UAM_create_airway_demo;
lanes = UAM_flight_path(airway,1,25);
min_t = 0;
max_t = 60;
speed = 1;
h_t = 1;
flights = [];

[fp1,dc1,flights] = UAM_reserve_flight(airway,flights,min_t,max_t,speed,...
    lanes,1,h_t);

[fp2,dc2,flights] = UAM_reserve_flight(airway,flights,min_t,max_t,speed,...
    lanes,2,h_t);

[fp3,dc3,flights] = UAM_reserve_flight(airway,flights,min_t,max_t,speed,...
    lanes,3,h_t);
tch = 0;
