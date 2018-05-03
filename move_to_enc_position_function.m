function [ ] = move_to_enc_position_function(sixk,xpos,ypos)
    addpath(genpath('../'));


    [curr_x,curr_y] = enc_position(sixk);
    while abs(curr_x - xpos) >= 8 || abs(curr_y - ypos) >= 8
        string = sprintf('D %i,%i,0',ceil((xpos-curr_x)/2),ceil((ypos-curr_y)/2));
        fprintf(sixk,string);
        fscanf(sixk);
        fscanf(sixk);
        fprintf(sixk,'GO111');
        fscanf(sixk);
        fscanf(sixk)
        pause(.05);
        fprintf(sixk,'TPE');
        fscanf(sixk);
        pos = fscanf(sixk);
        pos = strsplit(pos,',');
        disp(pos)
        curr_x = char(pos(1));
        curr_x = curr_x(5:numel(curr_x));
        curr_y = char(pos(2));
        curr_x = str2double(curr_x);curr_y = str2double(curr_y);
    end
end