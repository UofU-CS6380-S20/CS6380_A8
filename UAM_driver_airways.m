function aa = UAM_driver_airways
%

% Create ground vertex set
vertexes3x3 = [0,0; 20,0; 40,0; 0,20; 20,20; 40,20; 0,40; 20,40; 40,40];

% Create ground road set
edges3x3 = [1,2; 2,3; 1,4; 2,5; 3,6; 4,5; 5,6; 4,7; 5,8; 6,9; 7,8; 8,9];

% Choose launch locations
launch_vertexes = randperm(9);
launch_vertexes = launch_vertexes(1:5);

% Choose land locations
land_vertexes = randperm(9);
land_vertexes = land_vertexes(1:5);

% set minimum lane length in a roundabout
r_len = 2;

% Create airway
aa3x3 = UAM_create_airways(vertexes3x3,edges3x3,launch_vertexes,...
    land_vertexes,2);

% Display airway
UAM_show_airways(aa3x3);
