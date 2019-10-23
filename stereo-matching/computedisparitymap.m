close all;
clear all;

im0 = imread('im0.pgm');
im1 = imread('im1.pgm');

figure(1);
imshow(stereoAnaglyph(im0,im1));
title('Red-cyan composite view of the stereo images');

disparityRange = [-23 25];
disparityMap_left_5 = disparity(im0,im1,'BlockSize',...
    5,'DisparityRange',disparityRange);
disparityMap_right_5 = disparity(im1,im0,'BlockSize',...
    5,'DisparityRange',disparityRange);
disparityMap_left_7 = disparity(im0,im1,'BlockSize',...
    7,'DisparityRange',disparityRange);
disparityMap_right_7 = disparity(im1,im0,'BlockSize',...
    7,'DisparityRange',disparityRange);
disparityMap_left_13 = disparity(im0,im1,'BlockSize',...
    13,'DisparityRange',disparityRange);
disparityMap_right_13 = disparity(im1,im0,'BlockSize',...
    13,'DisparityRange',disparityRange);
disparityMap_left_21 = disparity(im0,im1,'BlockSize',...
    21,'DisparityRange',disparityRange);
disparityMap_right_21 = disparity(im1,im0,'BlockSize',...
    21,'DisparityRange',disparityRange);

figure(2);
subplot(1,2,1); 
imshow(disparityMap_left_21,disparityRange);
title('Disparity Map');
colormap(gca,jet) 
colorbar;
subplot(1,2,2); 
imshow(disparityMap_right_21,disparityRange);
title('Disparity Map');
colormap(gca,jet) 
colorbar;

figure(3);
vec_left = disparityMap_left_21(100,:);
plot(abs(vec_left));


subplot(2,4,1); plot(abs(disparityMap_left_5(100,:))); title('Measured disparity [left, Window size = 3]');
subplot(2,4,2); plot(abs(disparityMap_left_7(100,:))); title('Measured disparity [left, Window size = 7]');
subplot(2,4,3); plot(abs(disparityMap_left_13(100,:))); title('Measured disparity [left, Window size = 13]');
subplot(2,4,4); plot(abs(disparityMap_left_21(100,:))); title('Measured disparity [left, Window size = 21]');

subplot(2,4,5); plot(abs(disparityMap_right_5(100,:))); title('Measured disparity [right, Window size = 3]');
subplot(2,4,6); plot(abs(disparityMap_right_7(100,:))); title('Measured disparity [right, Window size = 7]');
subplot(2,4,7); plot(abs(disparityMap_right_13(100,:))); title('Measured disparity [right, Window size = 13]');
subplot(2,4,8); plot(abs(disparityMap_right_21(100,:))); title('Measured disparity [right, Window size = 21]');