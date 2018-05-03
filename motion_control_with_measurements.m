function [] = motion_control_with_measurements(startX, startY, endX, endY)
%MOTION_CONTROL_WITH_MEASUREMENTS Moves the plate the correct number of steps in each direction needed to move
%from startX to endX and startY to endY

addpath(genpath('../'));


A = [-148 -228; 213 -152];
B = [(endX-startX); (endY-startY)];
x = mldivide(A, B);

x_steps = x(1) * 1000;
y_steps = x(2) * 1000;

distance_command = strcat('D', num2str(x_steps));
distance_command = strcat(distance_command, ',');
distance_command = strcat(distance_command, num2str(y_steps));
distance_command = strcat(distance_command, ',1000');

disp(distance_command);

sixk = serial('COM6', 'BaudRate', 9600);
fopen(sixk);
fprintf(sixk, 'DRIVE111');

%fprintf(sixk, 'A5,5,5');
%fprintf(sixk, 'AD5,5,5');

fprintf(sixk, distance_command);
fprintf(sixk, 'GO1,1,');
fprintf(sixk, 'DRIVE000');
fclose(sixk);


end

