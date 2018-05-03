addpath(genpath('../'));


clc; clear all; close all;

sixk = serial('COM6', 'BaudRate', 9600);
fopen(sixk);
vid = videoinput('winvideo',1);
preview(vid)
fprintf(sixk, 'DRIVE111');
fprintf(sixk,'A30,30,30');
fprintf(sixk,'AA15,15,15');
fprintf(sixk,'AD30,30,30');
fprintf(sixk,'ADA15,15,15');
fprintf(sixk, 'D,,-10000');
fprintf(sixk,'GO,,1');

fprintf(sixk,'DRIVE000');
fclose(sixk);
