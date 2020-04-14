function flight_path = UAM_flight_path(airways,v1,v2)
% UAM_flight_path - find lane path from launch to land vertexes
% On input:
%     airways (airway struct): airways
%     v1 (int): ground vertex launch index
%     v2 (int): ground vertex land index
% On output:
%     path (1xn vector): lane indexes of path
% Call:
%     fp = UAM_flight_path(airways,7,23);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

lanes = airways.lanes;
G.vertexes = lanes(:,1:6);
G.edges = UAM_lane_edges(airways);
G.weights = UAM_lane_weights(airways);
initial_state = find(lanes(:,3)==0&lanes(:,7)==v1&lanes(:,8)==v1);
goal_state = find(lanes(:,6)==0&lanes(:,7)==v2&lanes(:,8)==v2);
h_name = 'UAM_A_star_Man';
s  = UAM_A_star(G,initial_state,goal_state,h_name);
flight_path = s(:,1);
