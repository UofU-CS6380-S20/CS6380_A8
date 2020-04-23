function b = UAM_route_type(flights)
%

b = 0;
if isempty(flights)
    return
end

num_flights = length(flights);
route = [flights(1).lanes(1),flights(1).lanes(end)];
for f = 2:num_flights
    if ~isequal([flights(f).lanes(1),flights(f).lanes(end)],route)
        b = 1;
        return
    end
end
