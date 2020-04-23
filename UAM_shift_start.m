function n_flight = UAM_shift_start(flight,delay)
% UAM_shift_start - delay start by delay
% On input:
%     flight (flight struct): flight info
%     delay (float): amount to delay flight
% On output:
%     n_flight (flight struct): new flight info
% Call:
%     nf = UAM_shift_start(f1,0.1);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

n_flight = flight;
n_flight.start_time = flight.start_time + delay;
n_flight.end_time = n_flight.end_time + delay;
flight_path = n_flight.flight_path;
flight_path(:,1:2) = flight_path(:,1:2) + delay;
n_flight.flight_path = flight_path;
