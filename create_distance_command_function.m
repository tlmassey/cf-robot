function [ command ] = create_distance_command_function( x_dist, y_dist, z_dist )
% Creates distance command by concatenating parameters separated by commas
% starting with d
addpath(genpath('../'));


command = strcat('D', num2str(x_dist));
command = strcat(command, ',');
command = strcat(command, num2str(y_dist));
command = strcat(command, ',');
command = strcat(command, num2str(z_dist));

end

