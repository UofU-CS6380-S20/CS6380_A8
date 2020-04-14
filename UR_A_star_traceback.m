function trace = UR_A_star_traceback(nodes,n)
% UR_A_star_traceback - trace back to initial state from goal state
% On input:
%     nodes (nodes data structure): nodes of search tree
%      (i).parent (int): index of parent node
%         .state (int): graph vertex index
%         .cost (int): cost from start to this node
%         .children (vector): list of children's node indexes
%     n (int): index of goal node
% On output:
%     trace (kx array): vertex index trace from start to goal
% Call:
%     t = UR_A_star_traceback(nodes,10);
% Author:
%     T. Henderson
%     UU
%     Fall 2019
%

trace = [nodes(n).state,nodes(n).f];
b = n;
while b>0
    b = nodes(b).parent;
    trace = [nodes(b).state,nodes(b).f;trace];
end
