function n_flight = UAM_deconflict2(s_flights,flight,del_t,h_t)
%

DELAY = 0.5;
DEL_T = 0.1;
MIN_SPEED = 5;
MAX_SPEED = 10;

n_flight = flight;
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

h_d = MAX_SPEED*h_t;
total_dist = 0;
for t = 1:length(traj(:,1))
    total_dist = total_dist + norm(traj(t,4:6)-traj(t,1:3));
end
time_required = total_dist/speed;
end_time = start_time + time_required;
possible = [];
for f = 1:num_flights
    f_grid_els = s_flights(f).grid_els;
    if ~isempty(intersect(n_grid_els,f_grid_els))
        possible = [possible,f];
    end
end
num_possible = length(possible);
if num_possible==0
    return
end
s_flights = s_flights(possible);
pinch = UAM_n_pinch_pts(s_flights,n_flight,num_flights+1,h_d);
[num_pinch,dummy] = size(pinch);

if num_pinch<1
    return
end

done = 0;
while done==0
    start_time = n_flight.start_time;
    speed = n_flight.speed;
    traj = n_flight.traj;
    flight_path = n_flight.flight_path;
    done = 1;
    for p = 1:num_pinch
        f2 = pinch(p,2);
        traj2 = s_flights(f2).traj;
        speed2 = s_flights(f2).flight_path(1,3);
        flight_path2 = s_flights(f2).flight_path;
        s1 = pinch(p,3);
        s2 = pinch(p,4);
        e11 = traj(s1,1:3);
        e12 = traj(s1,4:6);
        e21 = traj2(s2,1:3);
        e22 = traj2(s2,4:6);
        t1 = flight_path(s1,1:2);
        t2 = flight_path2(s2,1:2);
        overlap = UAM_intersect_intervals(t1,t2);
        too_close = 0;
        if ~isempty(overlap)
            done3 = 0;
            while done3==0
                done3 = 1;
                done2 = 0;
                t = overlap(1);
                while done2==0
                    P = e11 + speed*(t-t1(1))*(e12-e11)/norm(e12-e11);
                    Q = e21 + speed2*(t-t2(1))*(e22-e21)/norm(e22-e21);
                    w = P - Q;
                    if norm(w)<h_d
                        too_close = 1;
                        done2 = 1;
                    end
                    t = t + DEL_T;
                    if t>overlap(2)
                        done2 = 1;
                    end
                end
                if too_close==1
                    n_flight = UAM_shift_start(n_flight,DELAY);
                    t1 = n_flight.flight_path(s1,1:2);
                    overlap = UAM_intersect_intervals(t1,t2);
                    if ~isempty(overlap)
                        done3 = 0;
                    else
                        done3 = 1;
                    end
                    too_close = 0;
                end
            end
        end
    end
end
tch = 0;
