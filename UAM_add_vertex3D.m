function [vertexes3D,index] = UAM_add_vertex3D(vertexes3D_in,pt,edge_pair)
% UAM_add_vertex3D - update 3D vertex array and return indes of pt
% On input:
%     vertexes3D_in (nx5 array): 3D vertex data (x,y,z,v1,v2)
%     pt (1x3 vector): 3D point to add to 3D vertex set
%     edge_pair (1x2 vector): vertex indexes
% On output:
%     vertexes3D (nx5 array): updated 3D vertex data (x,y,z,v1,v2)
%     index (int): index of pt in vertexes3D
% Call:
%     [vv,ind] = UAM_add_vertex3D(vv,pt,ep);
% Author:
%     T. Henderson
%     UU
%     Spring 2020
%

vertexes3D = vertexes3D_in;

if isempty(vertexes3D)
    vertexes3D = [vertexes3D;pt,edge_pair];
    index = 1;
else
    index = find(vertexes3D(:,1)==pt(1)&vertexes3D(:,2)==pt(2)...
        &vertexes3D(:,3)==pt(3));
    if isempty(index)
        vertexes3D = [vertexes3D;pt,edge_pair];
        index = length(vertexes3D(:,1));
    end
end
