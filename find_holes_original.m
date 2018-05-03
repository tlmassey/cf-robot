%clc; clear all; close all;

function [cols, rows] = find_holes(current_image)
addpath(genpath('../'));


TEMPLATE = 'template.jpg';

template = im2double(imread(TEMPLATE));
%filtered_image = correctLighting(image, 'lab');
%filtered_template = correctLighting(template, 'lab');
gray_image = current_image;
gray_template = rgb2gray(template);
histeq_image = adapthisteq(gray_image);
histeq_template = adapthisteq(gray_template);
X = normxcorr2(histeq_template, histeq_image);

N = 36;
inds = zeros(N,1);
tempX = X(:);
adjacent = zeros(N:N);
%diagonal = zeros(N:N);
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
        
%         if(inds(i) ~= 0)
%             for j = 1:i-1
%                  temp = [temp_rows(i), temp_cols(i); temp_rows(j), temp_cols(j)];
%                  if(48 <= pdist(temp) && 52 >= pdist(temp))
%                         adjacent(i, j) = 1;
%                         adjacent(j, i) = 1;
%                  %else if(70 <= pdist(temp) && 72 >= pdist(temp))
%                          %diagonal(i, j) = 1;
%                          %diagonal(j, i) = 1;
%                      %end
%                  end
%             end
        
%             for j = i+1:N
%                  temp = [temp_rows(i), temp_cols(i); temp_rows(j), temp_cols(j)];
%                  if(48 <= pdist(temp) && 52 >= pdist(temp))
%                         adjacent(i, j) = 1;
%                         adjacent(j, i) = 1;
%                  %else if(68 <= pdist(temp) && 74 >= pdist(temp))
%                          %diagonal(i, j) = 1;
%                          %diagonal(j, i) = 1;
%                      %end
%                  end
%             end
%        end
     end
    
%     if(i == N)
%         adjacentNum = sum(adjacent);
%        % diagonalNum = sum(diagonal);
%         for k = 1:N;
%             if(adjacentNum(k) < 2 ) %|| diagonalNum(k) < 1)
%                 adjacentNum(:, k) = 0;
%                 adjacentNum(k, :) = 0;
%                 %diagonalNum(:, k) = 0;
%                 %diagonalNum(k, :) = 0;
%                 inds(k) = 0;
%                 i = k-1;
%                 break
%             end
%         end
%     end
        
    i = i + 1;
    
end

[rows, cols] = ind2sub(size(X), inds);
for i =1:N
    rows(i) = rows(i)-22;
    cols(i) = cols(i)-22;
end
figure
imshow(histeq_image);
hold on;
plot(cols, rows, 'r*');

hold on;
plot(800, 600, 'mo');

%end
