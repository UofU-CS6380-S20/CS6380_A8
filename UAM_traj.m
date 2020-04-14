function traj = UAM_traj(airways,flights,f_index,t1,t2,del_t)
%

traj = [];

% airway info
lanes = airways.lanes;

% flight info
start_time = flights(f_index).start_time;
%end_time = flights(f_index).end_time;
speed = flights(f_index).values(5);
lane_sequence = flights(f_index).lanes;
len_lane_sequence = length(lane_sequence);
flight_path = flights(f_index).flight_path;
[len_flight_path,dummy] = size(flight_path);
end_time = flight_path(end,2);

int1 = [start_time,end_time];
int2 = [t1,t2];
f_int = UAM_intersect_intervals(int1,int2);
if isempty(f_int)
    return
end

time1 = f_int(1) - start_time;
dist_done = speed*time1;
index = 0;
for p = 1:len_flight_path
    if flight_path(p,1)<=time1&time1<=flight_path(p,2)
        index = p;
        break
    end
end
lane_index = flight_path(index,4);
time_entry = flight_path(index,1);
time_exit = flight_path(index,2);
dist2lane = speed*(time_entry-start_time);
dist_in_lane = dist_done - dist2lane;
pt1 = lanes(lane_index,1:3);
pt2 = lanes(lane_index,4:6);
dir = pt2 - pt1;
dir = dir/norm(dir);
loc = pt1 + dist_in_lane*dir;

t_vals = [f_int(1):del_t:f_int(2)];
num_t_vals = length(t_vals);
for t_ind = 1:num_t_vals
    t = t_vals(t_ind);
    if time_entry<=t&t<time_exit
        d = speed*(t-time_entry);
        loc = pt1 + d*dir;
        traj = [traj;loc,t];
    else
        index = index + 1;
        lane_index = flight_path(index,4);
        time_entry = flight_path(index,1);
        time_exit = flight_path(index,2);
        pt1 = lanes(lane_index,1:3);
        pt2 = lanes(lane_index,4:6);
        dir = pt2 - pt1;
        dir = dir/norm(dir);
        d = speed*(t-time_entry);
        loc = pt1 + d*dir;
        traj = [traj; loc,t];
    end
end
tch = 0;