addpath(genpath('../'));


%% AUTOMATIC MODE

%% 
[image] = capture_image();
[cols, rows] = find_holes(image);
order = cols + rows;
position = [order, cols, rows];
[~, I] = sort(position(:, 1));
sorted_position = position(I, :);     %use the column indices from sort() to sort all rows of position
