function [] = move_function( direction, distance, sixk )
%Moves the plate in the specified direction and the number of steps of distance.

addpath(genpath('../'));


fprintf(sixk, 'A10,10,10');
fprintf(sixk, 'AD10,10,10');
fprintf(sixk, 'V1,1,1');

distance_command = create_distance_command_function(distance, distance, distance);
fprintf(sixk, distance_command);

fprintf(sixk, 'DRIVE111');


if (strcmp(direction, 'y') == 2)
    fprintf(sixk, 'GO1,,');
    disp('IF statement');
elseif (strcmp(direction, 'x') == 1)
    fprintf(sixk, 'GO1,,');
    disp('ELSE IF statement');
else
    fprintf(sixk,'GO,1,');
    disp('ELSE STATEMENT');

pause(5);    

fprintf(sixk, 'DRIVE000');

end

