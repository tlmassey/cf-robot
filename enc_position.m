

function [xpos, ypos] = enc_position(x)
addpath(genpath('../'));


% x = serial(COM6); fopen(x);
fprintf(x,'ENCCNT1111');
fprintf(x,'TPE');
pause(.4);
fscanf(x);
fscanf(x);
fscanf(x);
pos = fscanf(x);
pos = strsplit(pos,',');
xpos = char(pos(1));
xpos = xpos(5:numel(xpos));
disp(pos);
ypos = char(pos(2));
xpos = str2double(xpos);ypos = str2double(ypos);

end
