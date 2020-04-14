function [flight_plan,d_count,flights] = UAM_reserve_flight(airways,...
    flights_in,t_start,t_end,speed,lanes,id,h_t)
% UAM_reserve_flight - reserve a flight path
% On input:
%     airways (airway struct): airway info
%     flights_in (flights struct): flight info per lane
%       (k).flights (nx4 array): flight info per flight
%          col 1: lane entry time
%          col 2: lane exit time
%          col 3: speed in lane
%          col 4: lane number
%          col 5: flight ID
%     t_start (float): earliest launch time
%     t_end (float): latest launch time
%     speed (float): speed requested through all lanes
%     id (int): unique flight id
%     h_t (float): headway time
% On output:
%     flight_plan (mx4 array): flight plan (see flights above)
%     d_count (int): number of flights in lanes considered
%     flights (flights struct): flights info
% Call:
%     [fp,dc,ff] = UAM_reserve_flight(aa,ff,t1,t2,.5,lanes,13,2);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

d_count = 0;
flights = flights_in;
flight_plan = [];

if isempty(flights_in)
    for f = 1:length(airways.lanes)
        flights(f).flights = [];
    end
end
lengths = airways.lane_lengths(lanes);

possible = UAM_LSD([t_start,t_end],speed,lanes,lengths,flights,h_t);
if isempty(possible)
    return
end

num_lanes = length(lanes);

for c = 1:num_lanes
    [count,dummy] = size(flights(lanes(c)).flights);
    d_count = d_count + count;
end

flight_plan = zeros(num_lanes,5);
t1 = min(possible);
if length(t1)>1
    t1 = t1(1);
end
for c = 1:num_lanes
    lane_index = lanes(c);
    flight_plan(c,1) = t1;
    t2 = t1 + lengths(c)/speed;
    flight_plan(c,2) = t2;
    flight_plan(c,3) = speed;
    flight_plan(c,4) = lanes(c);
    flight_plan(c,5) = id;
    flights(lane_index).flights = [flights(lane_index).flights;...
        flight_plan(c,:)];
    t1 = t2;
end

tch = 0;
