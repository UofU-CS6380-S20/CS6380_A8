function [solution,nodes]  = UR_A_star(G,initial_state,goal_state,h_name)
% UR_A_star - A* algorithm for UAS
% On input:
%     G (graph structure): graph definition
%      .V (nx6 array): 3D endpoints of each lane
%      .E (px2 array): (directed) edges between vertexes
%      .w (px1 vector): weight on each edge
%     initial_state (int): vertex index
%     goal_state (int): vertex index
%     h_name (string): heuristic function
% On output:
%     solution (qx1 vector): solution sequence of lanes
%     nodes (search tree data structure): search tree
%       (i).parent (int): index of node's parent
%       (i).level (int): level of node in search tree
%       (i).state (int): vertex index
%       (i).g (float): path cost from root to node
%       (i).h (float): heuristic value (estimate from node to goal)
%       (i).cost (float): g + h   (called f value in text)
%       (i).children (1xk vector): list of node's children
% Call:
%[so,no] = UR_A_star(G,3,9,'UR_A_star_Man')
% so =  [3,6,9]
%
% no = 1x9 struct array with fields:
%    parent
%    level
%    state
%    action
%    cost
%    g
%    h
% Author:
%     T. Henderson
%     UU
%     Fall 2019
%

vertexes = G.vertexes;
edges = G.edges;
weights = G.weights;

nodes(1).parent = [];
nodes(1).level = 0;
nodes(1).state = initial_state;
nodes(1).g = 0;
point1 = vertexes(initial_state,:);
point2 = vertexes(goal_state,:);
nodes(1).cost = 0;
nodes(1).h = feval(h_name,point1,point2);
nodes(1).f = nodes(1).g + nodes(1).h;
nodes(1).children = [];
num_nodes = 1;
frontier = [1,initial_state];
explored = [];
while 1==1
    if isempty(frontier)
        solution = [];
        return
    end
    node_index = frontier(1,1);
    state = frontier(1,2);
    node = nodes(node_index);
    frontier = frontier(2:end,:);
    explored = [explored;node_index,state];
    if node.state==goal_state
        solution = UR_A_star_traceback(nodes,node_index);
        return
    end
    next_list = [];
    indexes = find(edges(:,1)==node.state);
    num_children = length(indexes);
    for c = 1:num_children
        next_state = edges(indexes(c),2);
        if isempty(find(frontier(:,2)==next_state))...
                &isempty(find(explored(:,2)==next_state))
            num_nodes = num_nodes + 1;
            nodes(num_nodes).parent = node_index;
            nodes(num_nodes).level = node.level + 1;
            nodes(num_nodes).state = next_state;
            nodes(num_nodes).g = node.g + weights(next_state);
            nodes(num_nodes).cost = nodes(num_nodes).g;
            point1 = vertexes(next_state,:);
            point2 = vertexes(goal_state,:);
            nodes(num_nodes).h = feval(h_name,point1,point2);
            nodes(num_nodes).f = nodes(num_nodes).g + nodes(num_nodes).h;
            nodes(num_nodes).children = [];
            nodes(node_index).children = [nodes(node_index).children,...
                num_nodes];
            next_list = [num_nodes,next_state;next_list];
        end
    end
    frontier = UR_A_star_priority_queue(next_list,frontier,nodes,1);
    tch = 0;
end
