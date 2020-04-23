function grid_els = UAM_grid_els1(pt1,pt2,x_min,y_min,x_max,y_max,grid_x,M,N)
% UAM_grid_els - find grid elements traversed from pt1 to pt2
% On input:
%     pt1 (1x3 vector): 3D point
%     pt2 (1x3 vector): 3D point
%     x_min (float): x min for grid
%     y_min (float): y min for grid
%     x_max (float): x max for grid
%     y_max (float): y max for grid
%     grid_x (float): spacing between grid lines
%     M (int): number of rows in grid
%     N (int): number of cols in grid
% On output:
%     grid_els (): grid elements
% Call:
%     flights_FN(f).grid_els = UAM_grid_els(traj(1,1:3),traj(end,4:6),...
%         x_min,y_min,x_max,y_max,grid_x,M,N);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

im = zeros(M,N);
r1 = floor((pt1(2)-y_min)/(y_max-y_min)*(M-1)) + 1;
c1 = floor((pt1(1)-x_min)/(x_max-x_min)*(N-1)) + 1;
pixel1 = [r1,c1];
r2 = floor((pt2(2)-y_min)/(y_max-y_min)*(M-1)) + 1;
c2 = floor(((pt2(1)-x_min)/(x_max-x_min))*(N-1)) + 1;
pixel2 = [r2,c2];
[rows,cols] = MNDAS_line_between(pixel1,pixel2);
num_pts = length(rows);
for p = 1:num_pts
    im(rows(p),cols(p)) = 1;
end

stepsr = [0:grid_x:M];
if stepsr(end)<M
    stepsr = [stepsr,M];
end
num_stepsr = length(stepsr);
stepsc = [0:grid_x:N];
if stepsc(end)<N
    stepsc = [stepsc,N];
end
num_stepsc = length(stepsc);

grid_els = [];
for ind1 = 1:num_stepsr-1
    b11 = stepsr(ind1);
    r1 = max(1,b11);
    b12 = stepsr(ind1+1);
    r2 = b12;
    for ind2 = 1:num_stepsc-1
        b21 = stepsc(ind2);
        c1 = max(1,b21);
        b22 = stepsc(ind2+1);
        c2 = b22;
        if sum(sum(im(r1:r2,c1:c2)))>0
            grid_els = [grid_els;ind1,ind2];
        end
    end
end

if ~isempty(grid_els)
    grid_els = unique((grid_els(:,2)-1)*(num_stepsr-1) + grid_els(:,1));
end
tch = 0;
