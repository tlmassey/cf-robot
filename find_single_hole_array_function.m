function [x_pixel, y_pixel] = find_single_hole_array_function(vid, index_of_hole)
% Return the entire array of holes.

addpath(genpath('../'));


image_with_wrong_dimensions = getsnapshot(vid);

%stop(vid);

%image_with_correct_dimensions = imresize(image_with_wrong_dimensions, 1.25);
image_with_correct_dimensions = image_with_wrong_dimensions;

IMAGE = image_with_correct_dimensions;
%TEMPLATE = 'template.jpg';
TEMPLATE = 'template_light.png';
image = im2double(IMAGE);
template = im2double(imread(TEMPLATE));
TEMPLATE_INFO = imfinfo(TEMPLATE);
TEMPLATE_WIDTH = TEMPLATE_INFO.Width;
TEMPLATE_HEIGHT = TEMPLATE_INFO.Height;
width_offset_factor = 0.5;
height_offset_factor = 0.5;
gray_image = rgb2gray(image);
gray_template = rgb2gray(template);
histeq_image = adapthisteq(gray_image);
histeq_template = adapthisteq(gray_template);
X = normxcorr2(histeq_template, histeq_image);

N = 36;

inds = zeros(N,1);
tempX = X(:);
adjacent = zeros(N:N);
i = 1;

while(i <= N)
    while (inds(i) == 0)
        [~, inds(i)] = max(tempX);
        tempX(inds(i)) = -inf;
        [temp_rows, temp_cols] = ind2sub(size(X), inds);
        
        for j = 1:i-1
            temp = [temp_rows(i), temp_cols(i); temp_rows(j), temp_cols(j)];
            if(40 >= pdist(temp) || 400<= pdist(temp))
                inds(i) = 0;
                break;
            end
        end
        
        for j = i+1:N
            temp = [temp_rows(i), temp_cols(i); temp_rows(j), temp_cols(j)];
            if(40 >= pdist(temp))
                inds(i) = 0;
                break;
            end
        end
    end
    
    i = i + 1;
end

[rows, cols] = ind2sub(size(X), inds);
for i =1:N
    rows(i) = rows(i)-(TEMPLATE_HEIGHT * height_offset_factor);
    cols(i) = cols(i)-(TEMPLATE_WIDTH * width_offset_factor);
end

indices = mergesort_function(cols, N);

for check_index = 1:N-1
    if abs(cols(indices(check_index)) - cols(indices(check_index + 1))) <= 1
        if rows(indices(check_index)) > rows(indices(check_index + 1))
            temp_index = indices(check_index);
            indices(check_index) = indices(check_index + 1);
            indices(check_index + 1) = temp_index;
        end
    end
end

index = N - index_of_hole + 1;
index_actual = indices(index);

x_pixel = cols(index_actual);
y_pixel = rows(index_actual);

hole = [x_pixel, y_pixel];

%start(vid);

%disp(hole);

end

