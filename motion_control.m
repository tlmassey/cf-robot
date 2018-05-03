clc; clear all; close all;

sixk = serial('COM6', 'BaudRate', 9600);
fopen(sixk);

fprintf(sixk, 'DRIVE111');
fprintf(sixk, 'D0,0,300');
fprintf(sixk, 'GO,,1');
fprintf(sixk, 'DRIVE000');

fclose(sixk);