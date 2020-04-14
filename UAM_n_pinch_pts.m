function pinch = UAM_n_pinch_pts(flights_FN,n_flight,n_index,h_x)
% UAM_n_pinch_pts - find pairwise flight segments within headway distance
% On input:
%     flights_FN (flight struct): current scheduled flights
%     n_flight (flight struct): new flight
%     n_index (int): new flight index in all flights struct
%     h_x (float): headway distance
% On output:
%     pinch (mx5 array): close segments info
%       col 1: flight 1 index
%       col 2: flight 2 index
%       col 3: flight 1 segment index
%       col 4: flight 2 segment index
%       col 5: min distance between segments
% Call:
%     pin = UAM_n_pinch_pts(flights_FN,flight,5,1.2);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

DEL_X = 0.1;

pinch = [];

num_flights = length(flights_FN);
traj1 = n_flight.traj;
grid_els1 = n_flight.grid_els;

%wb = waitbar(0,'pinch points');
for f2 = 1:num_flights
%    waitbar(f2/num_flights);
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
                    pinch = [pinch; n_index,f2,s1,s2,min_d];
%                     pinch = [pinch; n_index,f2,s1,s2,min_d,pt1,pt2,dist1,...
%                         dist2];
                end
            end
        end
    end
end
%close(wb);
