function grid_els = UAM_grid_els(grid,pt1,pt2,M,N)
% UAM_grid_els - find grid elements traversed from pt1 to pt2
% On input:
%     grid (grid struct): defines grid
%       .x_min (float): x min for grid
%       .y_min (float): y min for grid
%       .x_max (float): x max for grid
%       .y_max (float): y max for grid
%       .del_x (float): x axis spacing
%       .del_y (float): y axis spacing
%     pt1 (1x3 vector): 3D point
%     pt2 (1x3 vector): 3D point
%     M (int): number of rows in grid
%     N (int): number of cols in grid
% On output:
%     grid_els (nx1 vector): grid elements (linearized by column)
% Call:
%     flights_FN(f).grid_els = UAM_grid_els(grid,traj(1,1:3),...
%         traj(end,4:6),M,N);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

x_min = grid.x_min;
x_max = grid.x_max;
y_min = grid.y_min;
y_max = grid.y_max;
del_x = grid.del_x;
del_y = grid.del_y;

im = zeros(M,N);
x1 = pt1(1);
y1 = pt1(2);
r1 = M - floor((y1-y_min)/(y_max-y_min)*(M-1));
c1 = floor((x1-x_min)/(x_max-x_min)*(N-1)) + 1;
pixel1 = [r1,c1];
x2 = pt2(1);
y2 = pt2(2);
r2 = M - floor((y2-y_min)/(y_max-y_min)*(M-1));
c2 = floor((x2-x_min)/(x_max-x_min)*(N-1)) + 1;
pixel2 = [r2,c2];
[rows,cols] = MNDAS_line_between(pixel1,pixel2);
num_pts = length(rows);
for p = 1:num_pts
    im(rows(p),cols(p)) = 1;
end

stepsr = [0:del_y:M];
if stepsr(end)<M
    stepsr = [stepsr,M];
end
num_stepsr = length(stepsr);
stepsc = [0:del_x:N];
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
