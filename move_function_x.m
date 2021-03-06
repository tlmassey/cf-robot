function [] = move_function_x( distance, sixk )
%Moves the plate in the x direction and the number of steps of distance.

%{
ADJUSTMENT = 20;

fprintf(sixk, 'A10,10,10');
fprintf(sixk, 'AD10,10,10');
fprintf(sixk, 'V1,1,1');

distance_adjustment = distance;

if abs(distance) < ADJUSTMENT
    if distance < 0
        distance_adjustment = distance - ADJUSTMENT;
        disp(distance_adjustment);
    else
        distance_adjustment = distance + ADJUSTMENT;
        disp(distance_adjustment);
    end
end
%}
    
addpath(genpath('../'));


distance_command = create_distance_command_function(distance, distance, distance);
fprintf(sixk, distance_command);

fprintf(sixk, 'DRIVE100');
pause(5);
fprintf(sixk, 'GO1,,');
pause(5);
%fprintf(sixk, 'DRIVE000');

%{
if abs(distance) < ADJUSTMENT
    if distance < 0
        distance_adjustment = ADJUSTMENT;
        disp(distance_adjustment);
    else
        distance_adjustment = -1 * ADJUSTMENT;
        disp(distance_adjustment);    
    end
    
    distance_command = create_distance_command_function(distance_adjustment, distance_adjustment, distance_adjustment);
    fprintf(sixk, distance_command);

    fprintf(sixk, 'DRIVE111');
    fprintf(sixk, 'GO1,,');
    pause(5);
    fprintf(sixk, 'DRIVE000');
end
%}

end

