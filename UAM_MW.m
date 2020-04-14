function UAM_MW(airways,traj,t_min,t_max)
%

num_traj = length(traj);

clf
UAM_show_airways(airways);

start_indexes = zeros(num_traj,1);
end_indexes = zeros(num_traj,1);
for t = 1:num_traj
    end_indexes(t) = length(traj(t).traj(:,1));
    indexes = find(traj(t).traj(:,3)<=t_min);
    if ~isempty(indexes)
        start_indexes(t) = indexes(end);
    else
        start_indexes(t) = end_indexes(t) + 1;
    end
    cur_indexes(t) = start_indexes(t);
end

for t = t_min:t_max
    for tr = 1:num_traj
        if cur_indexes(tr)<end_indexes(tr)
            pt = traj(tr).traj(cur_indexes(tr),1:3);
            plot3(pt(1),pt(2),pt(3),'bo');
            drawnow
            cur_indexes(tr) = cur_indexes(tr) + 1;
        end
    end
end
