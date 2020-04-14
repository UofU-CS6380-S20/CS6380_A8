function res = UAM_FN_L_study(min_start,max_start,min_speed,max_speed,...
    del_t,grid_x_vals,h_t_vals,per_ll_vals,num_flights_vals,num_trials)
%
% res = UAM_FN_L_study(0,60,0.1,0.31,0.1,[50:-10:10],[1:3],[.25,.50,1],...
%     [100,500,1000],10);
%

UNSUC_THRESH = 60;

count = 0;
for k1 = 1:length(grid_x_vals)
    grid_x = grid_x_vals(k1);
    for k2 = 1:length(h_t_vals)
        h_t = h_t_vals(k2);
        for k3 = 1:length(per_ll_vals)
            per_ll = per_ll_vals(k3);
            for k4 = 1:length(num_flights_vals)
                num_flights = num_flights_vals(k4);
                count = count + 1;
                measures = zeros(num_trials,8);
                for t = 1:num_trials
                    t
                    [airways,flights,flights_FN] = UAM_FNSD_LSD_scenario(...
                        min_start,max_start,min_speed,max_speed,num_flights,...
                        del_t,h_t,grid_x,per_ll,per_ll);
                    res(count).airways = airways;
                    res(count).flights = flights;
                    res(count).flights_FN = flights_FN;
                    fst = zeros(num_flights,1);
                    fnst = zeros(num_flights,1);
                    for f = 1:num_flights
                        fst(f) = flights(f).start_time;
                        fnst(f) = flights_FN(f).start_time;
                    end
                    measures(t,1) = mean(fst);
                    measures(t,2) = max(fst);
                    measures(t,3) = length(find(fst>UNSUC_THRESH));
                    measures(t,4) = mean(fnst);
                    measures(t,5) = max(fnst);
                    measures(t,6) = length(find(fnst>UNSUC_THRESH));
                    measures(t,7) = sum([flights.d_count]);
                    measures(t,8) = sum([flights_FN(1).d_count]);
                end
                res(count).measures = [mean(measures),var(measures)];
            end
        end
    end
end    
    