function [x_pixel, y_pixel] = find_single_hole_function(vid)
addpath(genpath('../'));


% Find a single hole (either rightmost, or leftmost).

image_with_wrong_dimensions = getsnapshot(vid);
image_with_correct_dimensions = imresize(image_with_wrong_dimensions, 1.25);

IMAGE = image_with_correct_dimensions;
%TEMPLATE = 'template.jpg';
TEMPLATE = 'template_light.jpg';
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

% Find the leftmost column so we can start at the "first hole"
left_most_col = inf;
left_most_col_index = 0;
for i = 1:N
    if left_most_col > cols(i)
        left_most_col = cols(i);
        left_most_col_index = i;
    end
end

right_most_col = -inf;
right_most_col_index = 0;
for i = 1:N
    if right_most_col < cols(i)
        right_most_col = cols(i);
        right_most_col_index = i;
    end
end


right_most = [cols(right_most_col_index), rows(right_most_col_index)];

%image_size = size(histeq_image);
%left_most = [cols(left_most_col_index), rows(left_most_col_index)];
%image_mid = [image_size(2) / 2, image_size(1) / 2];


% Uncomment the lines below for a plot of the image and focused hole.

%disp(left_most);
%disp(right_most);

%disp(image_mid);

%imshow(histeq_image);
%hold on;
%plot(image_mid(1), image_mid(2), 'g*');
%plot(cols(right_most_col_index), rows(right_most_col_index), 'r*');
%hold on;

%delete(vid);
%clear vid;

%disp(right_most);

x_pixel = right_most(1);
y_pixel = right_most(2);

end

