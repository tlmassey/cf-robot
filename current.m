addpath(genpath('../'));


% clc; clear all; close all;
% 
% 
% sixk = serial('COM6', 'BaudRate', 9600);
% fopen(sixk);
% current_lst = [1.24:-.1:0.04];
% fprintf(sixk, 'DRIVE111');
% fprintf(sixk,'A30,30,30');
% fprintf(sixk,'AD30,30,30');
% fprintf(sixk,'AA15,15,15');
% fprintf(sixk,'ADA15,15,15');
% range_from = 1;
% range_to = numel(current_lst);
% vid = videoinput('winvideo', 1, 'MJPG_1600x1200');
% num_test = 3;
% for j = 1:num_test
%     disp(j);
%     x_test_images_before = zeros(1200,1600,range_to);
%     x_test_images_after = zeros(1200,1600,range_to);
%     for i = 1:range_to
%         image = getsnapshot(vid);
%         image = rgb2gray(im2double(image));
%         x_test_images_before(:,:,i) = image;
%         axis = serial('COM3', 'BaudRate', 9600);
%         fopen(axis);
%         fprintf(axis,sprintf('DMTIC %i',current_lst(i)));
%         fclose(axis);
%         pause(1);
%         fprintf(sixk,'D1000,0,0');
%         fprintf(sixk,'GO1,,');
%         pause_unit = .5;
%         pause(pause_unit);
%         image = getsnapshot(vid);
%         image = rgb2gray(im2double(image));
%         x_test_images_after(:,:,i) = image;
%         fprintf(sixk,'D-1000,,');
%         fprintf(sixk,'GO1,,');
%         pause(pause_unit);
%     end
%     save(sprintf('min_current_x/%i.mat',j));
%     clear x_test_images_before
%     clear x_test_images_after
% 
% end
% fprintf(sixk, 'DRIVE000');
% fclose(sixk);


clc; clear all; close all;


sixk = serial('COM6', 'BaudRate', 9600);
fopen(sixk);
current_lst = [1.24:-.1:0.04];
fprintf(sixk, 'DRIVE111');
fprintf(sixk,'A30,30,30');
fprintf(sixk,'AD30,30,30');
fprintf(sixk,'AA15,15,15');
fprintf(sixk,'ADA15,15,15');
range_from = 1;
range_to = numel(current_lst);
vid = videoinput('winvideo', 1, 'MJPG_1600x1200');
num_test = 3;
for j = 1:num_test
    disp(j);
    x_test_images_before = zeros(1200,1600,range_to);
    x_test_images_after = zeros(1200,1600,range_to);
    for i = 1:range_to
        image = getsnapshot(vid);
        image = rgb2gray(im2double(image));
        x_test_images_before(:,:,i) = image;
        axis = serial('COM5', 'BaudRate', 9600);
        fopen(axis);
        fprintf(axis,sprintf('DMTIC %i',current_lst(i)));
        fclose(axis);
        pause(1);
        fprintf(sixk,'D0,0,-4000');
        fprintf(sixk,'GO,,1');
        pause_unit = .5;
        pause(pause_unit);
        image = getsnapshot(vid);
        image = rgb2gray(im2double(image));
        x_test_images_after(:,:,i) = image;
        fprintf(sixk,'D,,4000');
        fprintf(sixk,'GO,,1');
        pause(pause_unit);
    end
    save(sprintf('min_current_z/%i.mat',j));
    clear x_test_images_before
    clear x_test_images_after

end
fprintf(sixk, 'DRIVE000');
fclose(sixk);

return;
clc; clear all; close all;


sixk = serial('COM6', 'BaudRate', 9600);
fopen(sixk);
current_lst = [5:5:100];
fprintf(sixk, 'DRIVE111');
fprintf(sixk,'A30,30,30');
fprintf(sixk,'AD30,30,30');
fprintf(sixk,'AA15,15,15');
fprintf(sixk,'ADA15,15,15');
range_from = 1;
range_to = numel(current_lst);
vid = videoinput('winvideo', 1, 'MJPG_1600x1200');
num_test = 3;
for j = 1:num_test
    disp(j);
    x_test_images_before = zeros(1200,1600,range_to+1);
    fprintf(sixk,'DAUTOS 0');
    image = getsnapshot(vid);
    image = rgb2gray(im2double(image));
    x_test_images_before(:,:,1) = image;
    for i = 1:range_to
        fprintf(sixk,sprintf('DAUTOS %i',current_lst(i)));
        image = getsnapshot(vid);
        image = rgb2gray(im2double(image));
        x_test_images_before(:,:,i+1) = image;
    end
    fprintf(sixk,'D,29,');
    fprintf(sixk,'GO,1,');
    save(sprintf('E:/round2/standby_current/%i.mat',j));
    clear x_test_images_before
    clear x_test_images_after

end
fprintf(sixk, 'DRIVE000');
fclose(sixk);
