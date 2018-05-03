function [e_curr,e_pos] = encoder(sixk,pos,axis)
addpath(genpath('../'));


fprintf(sixk,'DRIVE111');
fprintf(sixk,'TPE');
fscanf(sixk);
fscanf(sixk);
fscanf(sixk);
string = fscanf(sixk);
disp(string);
string = strsplit(string(5:numel(string)),',');
curr = str2double(string(axis));
counter = 0;
while curr ~= pos
    if counter > 10
        break;
    end
    string = ',,';
    val = int2str(floor((pos -curr)/2));
    string = strcat(string(1:axis-1),val,string(axis:numel(string)));
    fprintf(sixk,strcat('D',string));
    fscanf(sixk);
    fscanf(sixk);
    fprintf(sixk,strcat('GO',axis_bin));
    fscanf(sixk);
    fscanf(sixk)
    pause(.05);
    fprintf(sixk,'TPE');
    fscanf(sixk)
    string = fscanf(sixk)
    string
    string = strsplit(string(5:numel(string)),',');
    string
    curr = str2double(string(axis));
    counter = counter +1;
    e_curr = curr;
    e_pos = pos;
    
end
end


    