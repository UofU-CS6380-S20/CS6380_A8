function possible = UR_possible_times_int(possible0,speed,cor_list,...
    cor_lengths,flights,ht)
% UR_possible_times_int - provide possible strategically deconflicted
%      launch time intervals given a requested interval and the
%      scheduled flights
% On input:
%     possible0 (1x2 vector): first and last possible launch times
%     speed (float): speed to requesting UAS
%     cor_list (kx1 vector): list of corridors to be traversed (in order)
%     cor_lengths (kx1 vector): lengths of corridors to be traversed
%     flights (vector struct): scheduled flights (given per corridor)
%     ht (float): headway time
% On output:
%     possible (nx2 array): each row is a continuous interval of possible
%        starting flight times
% Call:
%     inters = UR_possible_times_int([4,35],2,[13,6,14],[500,6,500],fl,5);
% Author:
%     T. Henderson
%     UU
%     Summer 2019
%

len_cor_list = length(cor_list);
intervals = possible0;
offset = 0;
c = 0;
total_time = 0;
while ~isempty(intervals)&c<len_cor_list
    c = c + 1;
    dc = cor_lengths(c);
    cor = cor_list(c);
    ts = dc/speed;
%    ts = ceil(dc/speed);
    [num_intervals,dummy] = size(intervals);
    for k = 1:num_intervals
        intervals(k,:) = intervals(k,:) + [offset,offset];
    end
    c_flights = flights(cor).flights;
    if ~isempty(c_flights)
        [num_c_flights,dummy] = size(c_flights);
        f = 0;
        [num_intervals,dummy] = size(intervals);
        while f<num_c_flights&~isempty(intervals)
            f = f + 1;
            tr1 = min(intervals(:,1));
            tr2 = max(intervals(:,2));
            ts1 = c_flights(f,1);
            ts2 = c_flights(f,2);
            tr1e = tr1 + dc/speed;
            tr2e = tr2 + dc/speed;
%            tr1e = tr1 + ceil(dc/speed);
%            tr2e = tr2 + ceil(dc/speed);
            if ~((ts1+ht<=tr1&ts2+ht<=tr1e)|(ts1-ht>=tr2&ts2-ht>=tr2e))
                new_intervals = [];
                for k = 1:num_intervals
                    k_intervals = UR_OK_sched_req_enum(c_flights(f,1),...
                        c_flights(f,2),c_flights(f,3),intervals(k,1),...
                        intervals(k,2),speed,dc,ht);
                    new_intervals = UR_merge_intervals(k_intervals,...
                        new_intervals);
                end
                intervals = new_intervals;
                if isempty(intervals)
                    num_intervals = 0;
                else
                    num_intervals = length(intervals(:,1));
                end
            end
        end
        tch = 0;
    end
    offset = ts;
    total_time = total_time + ts;
end
total_time = total_time - ts;
[num_intervals,dummy] = size(intervals);
for k = 1:num_intervals
    intervals(k,:) = intervals(k,:) - [total_time,total_time];
end
if ~isempty(intervals)
    t1 = intervals(1,1);
    offset = 0;
    for c = 1:len_cor_list
        cor = cor_list(c);
        if ~isempty(flights(cor).flights)...
                &abs(t1-flights(cor).flights(1,1))<7
            tch = 0;
        end
        t1 = t1 + cor_lengths(c)/speed;
%        t1 = t1 + ceil(cor_lengths(c)/speed);
    end
end

% New way: return all intervals
possible = intervals;
return
