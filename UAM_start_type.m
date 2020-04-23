function b = UAM_start_type(flights)
%

b = 0;
if isempty(flights)
    return
end

num_flights = length(flights);
si = flights(1).start_interval;
for f = 2:num_flights
    if ~isequal(flights(f).start_interval,si)
        b = 1;
        return
    end
end
