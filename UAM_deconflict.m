function n_flight = UAM_deconflict(s_flights,flight,del_t,h_t)
% UAM_deconflict - uses FAA-NASA approach for deconfliction
% On input:
%     s_flights (flights struct): scheduled flights
%     flight (flight struct): new flight
%     del_t (float): time step
%     h_t (float): time headway
% On output:
%     n_flight (flight struct): new scheduled flight
% Call:
%     n_flight = UAM_deconflict(s_flights,n_flight,del_t,h_t);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

DELAY = 0.1;
DEL_T = 0.1;
MIN_SPEED = 5;
MAX_SPEED = 10;

grid_count = 0;
pinch_count = 0;
space_count = 0;
time_count = 0;

n_flight = flight;
n_flight.grid_count = 0;
n_flight.pinch_count = 0;
n_flight.space_count = 0;
n_flight.time_count = 0;
decon = 1;
start_time = n_flight.start_time;
n_grid_els = n_flight.grid_els;
if isempty(s_flights)
    return
end

num_flights = length(s_flights);
speed = n_flight.speed;
traj = n_flight.traj;
flight_path = n_flight.flight_path;

h_d = speed*h_t;
total_dist = 0;
for t = 1:length(traj(:,1))
    total_dist = total_dist + norm(traj(t,4:6)-traj(t,1:3));
end
time_required = total_dist/speed;
end_time = start_time + time_required;
n_flight.end_time = end_time;
possible = [];
for f = 1:num_flights
    f_grid_els = s_flights(f).grid_els;
    int_set = intersect(n_grid_els,f_grid_els);
    grid_count = grid_count + length(int_set);
    if ~isempty(int_set)
        possible = [possible,f];
    end
end
num_possible = length(possible);
if num_possible==0
    return
end
n_flight.d_count = num_possible;
s_flights = s_flights(possible);
pinch = UAM_n_pinch_pts(s_flights,n_flight,num_flights+1,h_d);
space_count = length([0:0.1:1])*num_flights;
n_flight.space_count = space_count;
[num_pinch,dummy] = size(pinch);
if num_pinch<1
    return
end
pinch_count = length(pinch(:,1));

done = 0;
while done==0  % shift start time until no pinch issues
    done = 1;
    for p = 1:num_pinch
        s1 = pinch(p,3);
        time_interval1 = n_flight.flight_path(s1,1:2);
        f2 = pinch(p,2);
        s2 = pinch(p,4);
        time_interval2 = s_flights(f2).flight_path(s2,1:2);
        overlap = UAM_intersect_intervals(time_interval1,time_interval2);
        if ~isempty(overlap)
            e11 = n_flight.traj(s1,1:3);
            e12 = n_flight.traj(s1,4:6);
            dir1 = e12 - e11;
            dir1 = dir1/norm(dir1);
            e21 = s_flights(f2).traj(s2,1:3);
            e22 = s_flights(f2).traj(s2,4:6);
            dir2 = e22 - e21;
            dir2 = dir2/norm(dir2);
            speed1 = n_flight.flight_path(s1,3);
            speed2 = s_flights(f2).flight_path(s2,3);
            t_vals = [overlap(1):del_t:overlap(2)];
            if t_vals(end)<overlap(2)
                t_vals(end+1) = overlap(2);
            end
            t = t_vals(1);
            too_close = 0;
            t_count = 0;
            while too_close==0&~isempty(overlap)&t<=overlap(2)
                P = e11 + speed1*(t-time_interval1(1))*dir1;
                Q = e21 + speed2*(t-time_interval2(1))*dir2;
                if norm(P-Q)<h_d
                    done = 0;
                    n_flight = UAM_shift_start(n_flight,DELAY);
                    time_interval1 = n_flight.flight_path(s1,1:2);
                    overlap = UAM_intersect_intervals(time_interval1,...
                        time_interval2);
                    too_close = 1;
                end
                t = t + del_t;
                t_count = t_count + 1;
            end
            time_count = time_count + t_count;
        end
    end
end
n_flight.pinch_count = pinch_count;
n_flight.grid_count = grid_count;
n_flight.time_count = time_count;

tch = 0;
