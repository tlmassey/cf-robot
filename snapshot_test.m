vid = videoinput('winvideo', 1,'MJPG_1600x1200');
time_lst = zeros(1,40);
for i = 1:40
    tic;
    img = getsnapshot(vid);
    img = rgb2gray(im2double(img));
    time_lst(i) = toc;
end
mean(time_lst)