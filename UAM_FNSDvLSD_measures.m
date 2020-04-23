function res = UAM_FNSDvLSD_measures(flights,flights_FN,airway,del_x,...
    del_t,delay)
% UAM_FNSDvLSD_measures - compute measures on FNSD vs LSD comparison
% On input:
%     flights (LSD flight struct): LSD flight data
%       .length (float): total flight distance
%       .d_time (float): time to reserve flight
%       .lanes (1xn vector): lanes used in flight
%       .start_interval (1x2 vector): possible start times interval
%       .flight_path (nx5 array): flight path data (by lane)
%          col 1: lane entry time
%          col 2: lane exit time
%          col 3: speed
%          col 4: lane number
%          col 5: flight ID
%       .d_count (int): sum(f_k*J_k)
%          where f_k is number of flight in lane k
%                J_k is number of intervals considered at lane k
%       .start_time (float): actual launch time
%       .end_time (float): actual land time
%     flights_FN (FNSD flight struct): FN flight data
%       .speed (float): speed through all lanes
%       .start_time (float): actual launch time
%       .start_interval (1x2 vector): possible start times interval
%       .flight_path (nx5 array): flight path data (by lane)
%          col 1: lane entry time
%          col 2: lane exit time
%          col 3: speed
%          col 4: lane number
%          col 5: flight ID
%        .d_count (int): not used
%        .grid_count (int): number grid overlaps with deonflicted flights
%        .pinch_count (int): number of close segments with other flights
%        .space_count (int): number spatial deconflict steps 
%        .time_count (int): number temporal deconflict steps
%        .d_time (float): wall clock deconfliction time
%        .end_time (float): landing time
%        .grid_els (1xk vector): grid elements overflown by flight
%     airway (airway struct): airway structure
%       .vertexes (nx2 array): ground vertex locatons
%       .edges (mx2 array): vertex indexes of edges
%       .r_len (float): minimal length of roundabout lane
%       .ground_launch_vertexes (1xq vector): launch ground vertexes
%       .ground_land_vertexes (1xp vector): land ground vertexes
%       .launch_lane_vertexes (1xq vector): launch lanes
%       .land_lane_vertexes (1xp vector): land lanes
%       .vertexes3D (fx5 array): 3D vertexes, and grounf vertex origins
%       .lanes (wx10 array): lane info
%         [x1 y1 z1 x2 y2 z2 ? ? ? ?]
%       .lane_lengths(wx1 vector): lengths of lanes
% On output:
%     res (result stuct): result info
%       .num_flights (int): number of flights
%       .start_distrib (int): 0: constant; 1: variable
%       .routes (int): 0: same one; 1: variety
%       .airway (airway struct): airway
%       .UAS_speed (int): 0: contant; 1: variable
%       .del_x (float): spatial step in FNSD deconfliction
%       .del_t (int): temporal step in FNSD deconfliction
%       .delay (float): time delay in launch time for deconfliction
%       .LSD_avg_delay (float): LSD average launch delay
%       .LSD_max_delay (float): LSD max launch delay
%       .LSD_average_flight_time (float): LSD average flight time
%       .LSD_nc_avg (float): LSD nc average
%       .LSD_nc_max (float): LSD nc max
%       .LSD_d_time (float): LSD avg deconfliction (wall clock) time
%       .FNSD_avg_delay (float): FNSD average flight delay
%       .FNSD_max_delay (float): FNSD max launch delay
%       .FNSD_avg_flight_time (float): FNSD average flight time
%       .FNSD_grid_count_avg (float): FNSD average grid element overlap
%       .FNSD_pinch_count_avg (float): FNSD average pinch count
%       .FNSD_space_count_avg (float): FNSD average spatial step
%       .FNSD_time_count_avg (float): FNSD average time step
%       .FNSD_d_time (float): FNSD average (wall clock) time
% Call:
%     res = UAM_FNSDvLSD_measures(ff1,ffn1,aa1,0.1,0.1,0.1);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

num_flights = length(flights);
res.num_flights = num_flights;
res.start_distrib = UAM_start_type(flights);
res.routes = UAM_route_type(flights);
res.airway = airway;
res.UAS_speed = UAM_speed_type(flights);
res.del_x = del_x;
res.del_t = del_t;
res.delay = delay;
res.LSD_avg_delay = 0;
res.LSD_max_delay = 0;
res.LSD_avg_flight_time = 0;
res.LSD_nc_avg = 0;
res.LSD_nc_max = 0;
res.LSD_d_time = 0;
res.FNSD_avg_delay = 0;
res.FNSD_max_delay = 0;
res.FNSD_avg_flight_time = 0;
res.FNSD_grid_count_avg = 0;
res.FNSD_pinch_count_avg = 0;
res.FNSD_space_count_avg = 0;
res.FNSD_time_count_avg = 0;
res.FNSD_d_time = 0;

res_info = [];

for f = 1:num_flights
    if ~isempty(flights(f).start_interval)
        r1 = flights(f).start_time - flights(f).start_interval(1);
        r2 = flights_FN(f).start_time - flights_FN(f).start_interval(1);
        r3 = flights(f).end_time - flights(f).start_time;
        r4 = flights_FN(f).end_time - flights_FN(f).start_time;
        r5 = flights(f).length;
        r6 = UAM_traj_length(flights_FN(f).traj);
        res_info = [res_info;r1,r2,r3,r4,r5,r6];
    end
end
res.LSD_avg_delay = mean(res_info(:,1));
res.LSD_max_delay = max(res_info(:,1));
res.LSD_avg_flight_time = mean(res_info(:,3));

% nc average & max
% average wall clock time
nc_avg = 0;
nc_max = 0;
avg_wc_time = 0;
for f = 1:num_flights
    nc_avg = nc_avg + flights(f).d_count;
    nc_max = max(nc_max,flights(f).d_count);
    avg_wc_time = avg_wc_time + flights(f).d_time;
end
nc_avg = nc_avg/num_flights;
avg_wc_time = avg_wc_time/num_flights;
res.LSD_nc_avg = nc_avg;
res.LSD_nc_max = nc_max;
res.LSD_d_time = avg_wc_time;

gc_avg = 0;
pc_avg = 0;
sc_avg = 0;
tc_avg = 0;
avg_wc_time = 0;
num_actual = 0;
avg_delay = 0;
max_delay = 0;
avg_ft = 0;
wc_times = [];
for f = 1:num_flights
    dt = flights_FN(f).d_time;
    if ~isempty(dt)&dt>0
        gc_avg = gc_avg + flights_FN(f).grid_count;
        pc_avg = pc_avg + flights_FN(f).pinch_count;
        sc_avg = sc_avg + flights_FN(f).space_count;
        tc_avg = tc_avg + flights_FN(f).time_count;
        avg_wc_time = avg_wc_time + flights_FN(f).d_time;
        delay_f = flights_FN(f).start_time-flights_FN(f).start_interval(1);
        avg_delay = avg_delay + delay_f;
        max_delay = max(max_delay,delay_f);
        avg_ft = avg_ft + flights_FN(f).end_time-flights_FN(f).start_time;
        wc_times = [wc_times,flights_FN(f).d_time];
        num_actual = num_actual + 1;
    end
end
gc_avg = gc_avg/num_actual;
pc_avg = pc_avg/num_actual;
sc_avg = sc_avg/num_actual;
tc_avg = tc_avg/num_actual;
avg_wc_time = avg_wc_time/num_actual;
avg_delay = avg_delay/num_actual;
avg_ft = avg_ft/num_actual;
res.FNSD_grid_count_avg = gc_avg;
res.FNSD_pinch_count_avg = pc_avg;
res.FNSD_space_count_avg = sc_avg;
res.FNSD_time_count_avg = tc_avg;
res.FNSD_d_time = avg_wc_time;
res.FNSD_avg_delay = avg_delay;
res.FNSD_max_delay = max_delay;
res.FNSD_avg_flight_time = avg_ft;

% estimated values
if num_actual<num_flights
    [pd,sd] = polyfit([1:num_actual],res_info(1:num_actual,2)',1);  % delay
    [pt,st] = polyfit([1:num_actual],wc_times,1);  % wall clock time
    valsd = polyval(pd,[1:1000]);
    res.FNSD_avg_delay = mean(valsd);
    valst = polyval(pt,[1:1000]);
    res.FNSD_d_time = mean(valst);
    res.FNSD_max_delay = valsd(end);
end

% -----------------------------------------------------------
function len = UAM_traj_length(traj)
%

len_traj = length(traj(:,1));
len = 0;
for s = 1:len_traj
    len = len + norm(traj(s,1:3)-traj(s,4:6));
end
