function [d,p1,p2] = UAM_dist_line_line(line1, line2)
% UAM_dist_line_line - distance between 2 lines
% Call: [d,p1,p2] = UAM_dist_line_line(line1,line2);
% On input:
%     line1: line defined by 2 points (matrix is 2x3)
%     line2: line defined by 2 points (matrix is 2x3)
% On output:
%     d (float): minimum distance between the 2 lines
%     p1 (3x1 vector): line1 pt closest to line2
%     p2 (3x1 vector): line2 pt closest to line1
% Author:
%     Tom Henderson
%     UU
%     7 January 2000; modified Spring 2020
%

d = Inf;
p1 = zeros(3,1);
p2 = zeros(3,1);

b = zeros(2,1);
A = zeros(2,2);
b(1) = line2(1,1) - line1(1,1);
b(2) = line2(1,2) - line1(1,2);
b(3) = line2(1,3) - line1(1,3);
A(1,1) = line1(2,1)-line1(1,1);
A(1,2) = -(line2(2,1)-line2(1,1));
A(2,1) = line1(2,2)-line1(1,2);
A(2,2) = -(line2(2,2)-line2(1,2));
A(3,1) = line1(2,3)-line1(1,3);
A(3,2) = -(line2(2,3)-line2(1,3));
g = A\b;   % find parameters for both lines
p1 = line1(1,:) + g(1)*(line1(2,:)-line1(1,:));   % find point on line 1
p2 = line2(1,:) + g(2)*(line2(2,:)-line2(1,:));   % find point on line 2
p = (p1+p2)/2;    % get midpoint
d = 2*cv_dist_pt_line(p,line1);   % distance is twice midpoint to line
