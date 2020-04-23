function res = UAM_FNSDvLSD_measures1(flights,flights_FN)
% UAM_FNSDvLSD_measures1 - compute measures on FNSD vs LSD comparison

% res
% res(1,1:4): avg flight delay, max flight delay for flights & flights_FN
% res(2,1:4): avg flight time, max flight time for flights and flights_FN
% res(3,1:4): avg flight dist, max flight dist for flights and flights_FN

num_flights = length(flights);
res = zeros(3,4);

res_info = zeros(num_flights,6);

for f = 1:num_flights
    res_info(f,1) = flights(f).start_time - flights(f).start_interval(1);
    res_info(f,2) = flights_FN(f).start_time ...
        - flights_FN(f).start_interval(1);
    res_info(f,3) = flights(f).end_time - flights(f).start_time;
    res_info(f,4) = flights_FN(f).end_time - flights_FN(f).start_time;
    res_info(f,5) = flights(f).length;
    res_info(f,6) = UAM_traj_length(flights_FN(f).traj);
end
res(1,1) = mean(res_info(:,1));
res(1,2) = max(res_info(:,1));
res(1,3) = mean(res_info(:,2));
res(1,4) = max(res_info(:,2));
res(2,1) = mean(res_info(:,3));
res(2,2) = max(res_info(:,3));
res(2,3) = mean(res_info(:,4));
res(2,4) = max(res_info(:,4));
res(3,1) = mean(res_info(:,5));
res(3,2) = max(res_info(:,5));
res(3,3) = mean(res_info(:,6));
res(3,4) = max(res_info(:,6));

function len = UAM_traj_length(traj)
%

len_traj = length(traj(:,1));
len = 0;
for s = 1:len_traj
    len = len + norm(traj(s,1:3)-traj(s,4:6));
end
