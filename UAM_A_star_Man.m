function d = UAM_A_star_Man(state1,state2)
% UAM_A_star_Man - computes Manhattan distance between two states
% On input:
%     state1 (1xn vector): state 1 vector
%     state2 (1xn vector): state 2 vector
% On output:
%     d (int): Manhattan distance
% Call:
%     d = UAM_A_star_Man([1,1,0],[2,2,1]);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

d = norm(state1-state2);
