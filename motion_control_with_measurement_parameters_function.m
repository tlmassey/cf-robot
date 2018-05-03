function [x_steps,y_steps] = motion_control_with_measurement_parameters_function( start_vector, end_vector, x_vector, y_vector, num_of_steps, sixk )
% First four parameters are vectors. Movement is start - end. x and y are
% vectors representing the pixel movement in both directions at the number
% of steps specified by the last parameter, num_of_steps.

% Modeling the equation: Ax = b, where x is the solution vector.
addpath(genpath('../'));


x_b_vector = end_vector(1) - start_vector(1);
y_b_vector = end_vector(2) - start_vector(2);
b_vector = [x_b_vector; y_b_vector];
A_matrix = [x_vector(1) y_vector(1); x_vector(2) y_vector(2)];
solution_vector = mldivide(A_matrix, b_vector);

x_steps = solution_vector(1) * num_of_steps;
y_steps = solution_vector(2) * num_of_steps;

move_function_x(x_steps, sixk);
move_function_y(y_steps, sixk);

end

