function n_flight = UAM_shift_start(flight,delay)
%

n_flight = flight;
n_flight.start_time = flight.start_time + delay;
n_flight.end_time = n_flight.end_time + delay;
flight_path = n_flight.flight_path;
flight_path(:,1:2) = flight_path(:,1:2) + delay;
n_flight.flight_path = flight_path;
