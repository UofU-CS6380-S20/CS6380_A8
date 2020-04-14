function queue_out = UR_A_star_priority_queue(next_list,queue,nodes,option)
% UR_A_star_priority_queue - priority queue for A* algorithm
% On input:
%     next_list (1xk vector): list of indexes of nodes to be inserted
%     queue (1xn vector): prioritized list of nodes
%     nodes (search tree data structure): search tree nodes
%     option (int): if 1 then put new states before equal cost states,
%                   else after
% On output:
%     queue_out (1x(n+k) vector): queue with next_list indexes inserted
% Call:
%     qo = UR_A_star_priority_queue(nl,q,nodes,1);
% Author:
%     T. Henderson
%     UU
%     Fall 2019
%

if isempty(next_list)
    queue_out = queue;
    return
end

if option==1
    queue1 = [next_list;queue];
else
    queue1 = [queue;next_list];
end
len_queue1 = length(queue1(:,1));
costs = zeros(len_queue1,1);
for n = 1:len_queue1
    costs(n) = nodes(queue1(n,1)).cost;
end
[vals,indexes] = sort(costs);
queue_out = queue1(indexes,:);
