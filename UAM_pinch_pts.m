function pinch = UAM_pinch_pts(flights_FN,h_x)
%

DEL_X = 0.1;

pinch = [];

num_flights = length(flights_FN);
wb = waitbar(0,'pinch points');
for f1 = 1:num_flights-1
    waitbar(f1/num_flights);
    traj1 = flights_FN(f1).traj;
    grid_els1 = flights_FN(f1).grid_els;
    for f2 = f1+1:num_flights
        traj2 = flights_FN(f2).traj;
        grid_els2 = flights_FN(f2).grid_els;
        if ~isempty(intersect(grid_els1,grid_els2))
            for s1 = 1:3
                P0 = traj1(s1,1:3);
                P1 = traj1(s1,4:6);
                for s2 = 1:3
                    Q0 = traj2(s2,1:3);
                    Q1 = traj2(s2,4:6);
                    [min_d,pt1,pt2] = UAM_quad(P0,P1,Q0,Q1,DEL_X);
                    if min_d<h_x
                        dist1 = 0;
                        for s = 1:s1-1
                            dist1 = dist1 + norm(traj1(s,4:6)-traj1(s,1:3));
                        end
                        dist1 = dist1 + norm(pt1-traj1(s1,1:3));
                        dist2 = 0;
                        for s = 1:s2-1
                            dist2 = dist2 + norm(traj2(s,4:6)-traj2(s,1:3));
                        end
                        dist2 = dist2 + norm(pt2-traj2(s2,1:3));
                        pinch = [pinch; f1,f2,s1,s2,min_d,pt1,pt2,dist1,...
                            dist2];
                    end
                end
            end
        end
    end
end
close(wb);
