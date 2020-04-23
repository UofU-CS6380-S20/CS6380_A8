function b = UAM_speed_type(flights)
%

b = 0;
if isempty(flights)
    return
end

num_flights = length(flights);
speed = flights(1).flight_path(1,3);
for f = 2:num_flights
    if ~isequal(flights(f).flight_path(1,3),speed)
        b = 1;
        return
    end
end
