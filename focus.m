function [rtn] = focus(vid)
addpath(genpath('../'));


sixk = serial('COM6', 'BaudRate', 9600);
fopen(sixk);
fprintf(sixk, 'DRIVE111');
%vid = videoinput('winvideo', 1);
%preview(vid);
mark = 0;
num_vectors = 30;
% 1. Units of the distances;
correlations = zeros(1,1);
motor_step = 100;
scan_step = 100;
con = 1;
%reference_image = imread('template.bmp');% capture reference image in the first iteration of the loop.
reference_image = getsnapshot(vid);
reference_image = rgb2gray(reference_image);
im_size = size(reference_image);
FSV_step = fix(im_size(1)/num_vectors);
%FSV_ref = zeros(1,num_vectors*im_size(2));
FSV_ref = zeros(im_size(1),num_vectors);
for j = 1:num_vectors
    FSV_ref(:,j) = abs(fft(reference_image(:,FSV_step*j)));
    %FSV_ref(im_size(1)*(j-1) +1: im_size(1)*j) = transpose(fft(reference_image(:,FSV_step*j)));

end
FSV_list = zeros(im_size(1),num_vectors,scan_step);

while con ==1
    corr_list = zeros(1,scan_step);
    if mark==1
        reference_image = getsnapshot(vid);
        reference_image = rgb2gray(reference_image);
        im_size = size(reference_image);
        FSV_step = fix(im_size(1)/num_vectors);
        %FSV_ref = zeros(1,num_vectors*im_size(2));
        FSV_ref = zeros(im_size(1),num_vectors);
        for j = 1:num_vectors
            FSV_ref(:,j) = abs(fft(reference_image(:,FSV_step*j)));
            %FSV_ref(im_size(1)*(j-1) +1: im_size(1)*j) = transpose(fft(reference_image(:,FSV_step*j)));

        end
    end
        
    for i = 1:scan_step
         fprintf(sixk, sprintf('D,,%i',motor_step)); % move in increments of 1mm.
         fprintf(sixk, 'GO,,1');
         pause(.05);
         disp(i)
        image =getsnapshot(vid);

        image = rgb2gray( image );
        im_size = size(image);
        FSV_step = fix(im_size(1)/num_vectors);
        FSV = zeros(im_size(1),num_vectors);
        for j = 1:num_vectors
            FSV(:,j) = abs(fft(image(:,FSV_step*j)));
            %FSV(im_size(1)*(j-1) +1: im_size(1)*j) = transpose(fft(reference_image(:,FSV_step*j)));
        end

        FSV_list(:,:,i) = FSV;
    end
    for i = 1:scan_step
        %correlation = corrcoef(transpose(FSV_list(i,:)),transpose(FSV_ref));
        correlation = corrcoef(FSV_ref,FSV_list(:,:,i));
        corr_list(i) = correlation(2,1);
    end
%     %go 75percent.
    if mark ==1
        [value,ind] = min(corr_list);
        
        fprintf(sixk,sprintf('D,,-%i',motor_step*(numel(corr_list)-ind)));
        fprintf(sixk,'GO,,1');
        
        
        
        fprintf(sixk, 'DRIVE000');
        fclose(sixk);
        return
    end
    if min(corr_list) == corr_list(numel(corr_list))
        con = 1;
    else
        mark = 1;
        con = 1;
        [value,ind] = min(corr_list);
        
        fprintf(sixk,sprintf('D,,-%i',motor_step*(numel(corr_list)-ind +2)));
        motor_step = fix(motor_step/10);
        fprintf(sixk,'GO,,1');
    end

    
    
    
end
    




fprintf(sixk, 'DRIVE000');

fclose(sixk);
end