function [ ] = find_holes_step_by_step_function( num_of_holes,vid )
%find_holes_step_by_step_function code copied from find_single_hole_autonomous
%to make compatible with the GUI.
addpath(genpath('../'));



NUM_OF_STEPS = 1000;
IMAGE_MID_X = 800;
IMAGE_MID_Y = 600;
image_mid = [IMAGE_MID_X, IMAGE_MID_Y];
HOLE_NUM = 1;
TOTAL_NUM_OF_HOLES = num_of_holes;

sixk = serial('COM6', 'BaudRate', 9600);
fopen(sixk);

% vid = videoinput('winvideo', 1);
% preview(vid);

%num_of_steps_array = [1000 200];

%for NUM_OF_STEPS = num_of_steps_array
%while NUM_OF_STEPS > 10
[x_init, y_init] = find_single_hole_array_function(vid, HOLE_NUM);
initial = [x_init; y_init];
move_function_x(NUM_OF_STEPS, sixk);
[x_x_vec, y_x_vec] = find_single_hole_array_function(vid, HOLE_NUM);
x_vec = [(x_x_vec - x_init); (y_x_vec - y_init)];
move_function_x(-1 * NUM_OF_STEPS, sixk);
move_function_y(NUM_OF_STEPS, sixk);
[x_y_vec, y_y_vec] = find_single_hole_array_function(vid, HOLE_NUM);
y_vec = [(x_y_vec - x_init); (y_y_vec - y_init)];
move_function_y(-1 * NUM_OF_STEPS, sixk);

motion_control_with_measurement_parameters_function(initial, image_mid, x_vec, y_vec, NUM_OF_STEPS, sixk);
    %NUM_OF_STEPS = NUM_OF_STEPS / 2;
%end
pause(5);

NUM_OF_STEPS = 200;
[x_init, y_init] = find_single_hole_array_function(vid, HOLE_NUM);
initial = [x_init; y_init];
move_function_x(NUM_OF_STEPS, sixk);
[x_x_vec, y_x_vec] = find_single_hole_array_function(vid, HOLE_NUM);
x_vec_200 = [(x_x_vec - x_init); (y_x_vec - y_init)];
move_function_x(-1 * NUM_OF_STEPS, sixk);
move_function_y(NUM_OF_STEPS, sixk);
[x_y_vec, y_y_vec] = find_single_hole_array_function(vid, HOLE_NUM);
y_vec_200 = [(x_y_vec - x_init); (y_y_vec - y_init)];
move_function_y(-1 * NUM_OF_STEPS, sixk);

NUM_OF_STEPS = 50;

[x_init, y_init] = find_single_hole_array_function(vid, HOLE_NUM);
initial = [x_init; y_init];
move_function_x(NUM_OF_STEPS, sixk);
[x_x_vec, y_x_vec] = find_single_hole_array_function(vid, HOLE_NUM);
x_vec = [(x_x_vec - x_init); (y_x_vec - y_init)];
move_function_x(-1 * NUM_OF_STEPS, sixk);
move_function_y(NUM_OF_STEPS, sixk);
[x_y_vec, y_y_vec] = find_single_hole_array_function(vid, HOLE_NUM);
y_vec = [(x_y_vec - x_init); (y_y_vec - y_init)];
move_function_y(-1 * NUM_OF_STEPS, sixk);

for hole = 1:TOTAL_NUM_OF_HOLES
    counter = 0;
    HOLE_NUM = hole;
    [x_init, y_init] = find_single_hole_array_function(vid, HOLE_NUM);
    initial = [x_init; y_init];
    motion_control_with_measurement_parameters_function(initial, image_mid, x_vec_200, y_vec_200, 200, sixk);
    pause(5);
    
    [x_init, y_init] = find_single_hole_array_function(vid, HOLE_NUM);
    initial = [x_init; y_init];
    while abs(x_init - 800) > 1 || abs(y_init - 600) > 1
        if counter > 15
            break
        end
        motion_control_with_measurement_parameters_function(initial, image_mid, x_vec, y_vec, NUM_OF_STEPS, sixk);
    
        pause(5);
        [x_init, y_init] = find_single_hole_array_function(vid, HOLE_NUM);
        initial = [x_init; y_init];
        counter = counter + 1;
    end

    disp(strcat('We are now at hole ', int2str(HOLE_NUM)));
    prompt = 'F/C/E Feeder/Continue/Exit';
    x = input(prompt);
    if x == 'F'
        feed = serial('COM12');fopen(feed);pause(3);
        fwrite(feed,'1');
        fwrite(feed,number);
        fclose(feed);
        disp('feeder');
    elseif x == 'C'
        disp('continue');
    else 
        disp('finished');
        return;
    end
    
%     
    find_single_hole_array_disp_function(vid, HOLE_NUM);
end

delete(vid);

fclose(sixk);

end

