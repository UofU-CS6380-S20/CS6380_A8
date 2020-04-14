function intervals = UAM_OK_sched_req_enum(ts1,ts2,s_s,tr1,tr2,s_r,d,ht)
% UAM_OK_sched_req_enum - determine OK intervals for proposed flight in
%                        specific corridor
% On input:
%     ts1 (float): start of scheduled flight
%     ts2 (float): end of scheduled flight
%     s_s (float): speed of scheduled flight
%     tr1 (float): min start time requested
%     tr2 (float): max start time requested
%     s_r (float): speed of requested flight
%     d (float): corridor length
%     ht (float): headway time
% On output:
%     intervals (nx2 array): possible start time intervals
% Call:
%     int1 = UAM_OK_sched_req_enum(23,51,5,8,40,3,49,5);
% Author:
%     T. Henderson
%     UU
%     Summer 2019
%

ZERO_THRESH = 0.01;

UAM_load_itable;

intervals = [];

t_across = d/s_r;
%t_across = ceil(d/s_r);
p1 = ts1 - ht;
p2 = ts1 + ht;
p3 = ts2 + ht;
p4 = ts2 - ht;
q1 = tr1;
q2 = tr2;
q3 = tr2 + t_across;
q4 = tr1 + t_across;

if p1<q1
    i1 = 1;
elseif abs(p1-q1)<ZERO_THRESH
    i1 = 2;
elseif p1>q1&p1<q2
    i1 = 3;
elseif abs(p1-q2)<ZERO_THRESH
    i1 = 4;
else
    i1 = 5;
end
if p2<q1
    i3 = 1;
elseif abs(p2-q1)<ZERO_THRESH
    i3 = 2;
elseif p2>q1&p2<q2
    i3 = 3;
elseif abs(p2-q2)<ZERO_THRESH
    i3 = 4;
else
    i3 = 5;
end

if p3<q4
    i4 = 1;
elseif abs(p3-q4)<ZERO_THRESH
    i4 = 2;
elseif p3>q4&p3<q3
    i4 = 3;
elseif abs(p3-q3)<ZERO_THRESH
    i4 = 4;
else
    i4 = 5;
end
if p4<q4
    i2 = 1;
elseif abs(p4-q4)<ZERO_THRESH
    i2 = 2;
elseif p4>q4&p4<q3
    i2 = 3;
elseif abs(p4-q3)<ZERO_THRESH
    i2 = 4;
else
    i2 = 5;
end

index = find(itable(:,1)==i1&itable(:,2)==i2&itable(:,3)==i3...
    &itable(:,4)==i4);
if isempty(index)
    tch = 0;
else
    switch index
        case {1,2,6,7,123,124,136,137}
            intervals = [q1,q2];
        case {3,8,26,29,32,37,40,43}
            intervals = [p3-t_across,q2];
        case {4,9,14,16,17,18,19,27,30,33,38,41,44,61,62,63,86,87,88}
            intervals = [q2,q2];
        case {11,12,58,59,60,83,84,85}
            intervals = [p2,q2];
        case 13
            if s_s<s_r
                intervals = [p3-t_across,q2];
            else
                intervals = [p2,q2];
            end
        case 69
            intervals = [p1,q1; p2,q2];
        case {70,73}
            intervals = [p1,q1; q2,q2];
        case {71,74,75,76,77,78,79,80,81,82}
            intervals = [p1,q1];
        case 72
            intervals = [p1,q1; p3-t_across,q2];
        case {92,93}
            intervals = [q1,q1;q2,q2];
        case 97
            if s_s<s_r
                intervals = [q1,p1; p3-t_across,q2];
            elseif s_s==s_r
                intervals = [q1,p1; p2,q2];
            else
                intervals = [q1,p4-t_across; p2,q2];
            end
        case {94,95,96,117,118,119,130,131,132}
            intervals = [q1,q1];
        case {98,101}
            intervals = [q1,p1; q2,q2];
        case 100
            intervals = [p1,p4-t_across; q2,q2];
        case {99,102,106,107,108,109,110,111}
            intervals = [q1,p1];
        case 105
            if s_s<=s_r
                intervals = [q1,p1];
            else
                intervals = [q1,p4-t_across];
            end
        case {103,104,120,121,122,133,134,135}
            intervals = [q1,p4-t_across];
    end
end
