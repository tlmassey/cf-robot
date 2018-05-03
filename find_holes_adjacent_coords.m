addpath(genpath('../'));


clc; clear all; close all;

%sixk = serial('COM6', 'BaudRate', 9600);
%fopen(sixk);
%preview(vid);

%imshow(histeq_image);
%hold on;

big_loop = 0;

while big_loop < 20
    
vid = videoinput('winvideo', 1);

image_with_wrong_dimensions = getsnapshot(vid);
image_with_correct_dimensions = imresize(image_with_wrong_dimensions, 1.25);


%index_actual = indices(index);

IMAGE = image_with_correct_dimensions;
TEMPLATE = 'template.jpg';
image = im2double(IMAGE);
template = im2double(imread(TEMPLATE));
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

index_of_hole = 20;

index = N - index_of_hole + 1;

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
    rows(i) = rows(i)-22;
    cols(i) = cols(i)-22;
end

%for hole_num = 1:N 
    indices = mergesort_function(cols, N);
    %x_pixel = cols(index_actual);
    %y_pixel = rows(index_actual);

    %disp([x_pixel, y_pixel]);
%end

for check_index = 1:N-1
    if abs(cols(indices(check_index)) - cols(indices(check_index + 1))) <= 1
        if rows(indices(check_index)) > rows(indices(check_index + 1))
            temp_index = indices(check_index);
            indices(check_index) = indices(check_index + 1);
            indices(check_index + 1) = temp_index;
        end
    end
end

%for check = 1:N-1
index_actual = indices(index);
disp([cols(index_actual), rows(index_actual)]);
%disp(index_actual);
%disp(cols);
%end

big_loop = big_loop + 1;

end
%hole = [x_pixel, y_pixel];
delete(vid);

%fclose(sixk);
