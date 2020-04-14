function flight_plan = UR_find_fp(t1,td,t2,speed,v1,v2,ht,g_flights,...
    g_airways,g_launch_time_policy)
% UR_find_fp - find flight plan, if possible
% On input:
%     t1 (float): initial possible launch time
%     td (float): desired launch time
%     t2 (float): final possible launch time
%     speed (float): request vehicle's speed
%     v1 (int): launch vertex index
%     v2 (int): lan vertex index
%     ht (float): headway time
%     g_flights (vector struct): flight info per lane
%     g_airways (sturct): airways struct
%     g_launch_time_policy (string): name of scheduling policy function
% On output:
%     flight_plan (nx4 array): flight plan
%       (i,:): [ti1, ti2, speed, corridor_i]
% Call:
%     fp = UR_find_fp(1,12,30,5,12,15,5,flights,airways,'UR_A2_policy');
% Author:
%     T. Henderson
%     UU
%     Summer 2019
%     Modified Fall 2019
%

%global g_flights
%global g_airways
%global g_launch_time_policy

flight_plan = [];

corridors = g_airways.corridors;
launch_vertexes = g_airways.launch_vertexes;
land_vertexes = g_airways.land_vertexes;

if isempty(find(launch_vertexes==v1))
    return
end
if isempty(find(land_vertexes==v2))
    return
end

%cor_list = UR_shortest_path_cor(v1,v2,g_airways);
G.vertexes = g_airways.corridors(:,1:6);
G.edges = g_airways.cor_edges;
G.weights = g_airways.cor_lengths;

[so,no] = UR_A_star(G,v1,v2,'UR_A_star_Eu');

if isempty(cor_list)
    return
end

%ht = 25;
len_cor_list = length(cor_list);
cor_lengths = zeros(len_cor_list,1);
for c = 1:len_cor_list
    cor_lengths(c) = norm(corridors(cor_list(c),1:3)...
        -corridors(cor_list(c),4:6));
end
flights = g_flights;
possible0 = [t1,t2];

possible = UR_possible_times_int(possible0,speed,cor_list,cor_lengths,...
    flights,ht);

if isempty(possible)
    return
else
    t_start = feval(g_launch_time_policy,possible,td);
    if isempty(t_start)
        return
    end
end

%t_start = possible(1);

flight_plan = zeros(len_cor_list,4);
t1 = t_start;
for c = 1:len_cor_list
    flight_plan(c,1) = t1;
    t2 = t1 + cor_lengths(c)/speed;
    flight_plan(c,2) = t2;
    flight_plan(c,3) = speed;
    flight_plan(c,4) = cor_list(c);
    t1 = t2;
end
tch = 0;
