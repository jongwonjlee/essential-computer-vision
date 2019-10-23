close all;
clear all;

im0 = imread('im0.pgm');
im1 = imread('im1.pgm');

gt_disparity0 = imread('gt_disp0.pgm');
gt_vec0 = double(gt_disparity0(100,:))/8';

gt_disparity1 = imread('gt_disp1.pgm');
gt_vec1 = double(gt_disparity1(100,:))/8';

disp_threshold = 600;
row = 100;

%% SSD

disparity_left_3 = ssd(im1,im0,3,disp_threshold,row);
disparity_right_3 = ssd(im0,im1,3,disp_threshold,row);
disparity_left_7 = ssd(im1,im0,7,disp_threshold,row);
disparity_right_7 = ssd(im0,im1,7,disp_threshold,row);
disparity_left_13 = ssd(im1,im0,13,disp_threshold,row);
disparity_right_13 = ssd(im0,im1,13,disp_threshold,row);
disparity_left_21 = ssd(im1,im0,21,disp_threshold,row);
disparity_right_21 = ssd(im0,im1,21,disp_threshold,row);

figure(1);
set(gca, 'PlotBoxAspectRatio', [1 0.3 1]);
subplot(2,5,1); plot(gt_vec0); title('Ground Truth [left]');
subplot(2,5,2); plot(disparity_left_3); title('Measured disparity [left, Window size = 3]');
subplot(2,5,3); plot(disparity_left_7); title('Measured disparity [left, Window size = 7]');
subplot(2,5,4); plot(disparity_left_13); title('Measured disparity [left, Window size = 13]');
subplot(2,5,5); plot(disparity_left_21); title('Measured disparity [left, Window size = 21]');

subplot(2,5,6); plot(gt_vec1); title('Ground Truth [right]');
subplot(2,5,7); plot(disparity_right_3); title('Measured disparity [right, Window size = 3]');
subplot(2,5,8); plot(disparity_right_7); title('Measured disparity [right, Window size = 7]');
subplot(2,5,9); plot(disparity_right_13); title('Measured disparity [right, Window size = 13]');
subplot(2,5,10); plot(disparity_right_21); title('Measured disparity [right, Window size = 21]');

%% SAD

disparity_left_3 = sad(im1,im0,3,disp_threshold,row);
disparity_right_3 = sad(im0,im1,3,disp_threshold,row);
disparity_left_7 = sad(im1,im0,7,disp_threshold,row);
disparity_right_7 = sad(im0,im1,7,disp_threshold,row);
disparity_left_13 = sad(im1,im0,13,disp_threshold,row);
disparity_right_13 = sad(im0,im1,13,disp_threshold,row);
disparity_left_21 = sad(im1,im0,21,disp_threshold,row);
disparity_right_21 = sad(im0,im1,21,disp_threshold,row);

figure(2);
subplot(2,5,1); plot(gt_vec0); title('Ground Truth [left]');
subplot(2,5,2); plot(disparity_left_3); title('Measured disparity [left, Window size = 3]');
subplot(2,5,3); plot(disparity_left_7); title('Measured disparity [left, Window size = 7]');
subplot(2,5,4); plot(disparity_left_13); title('Measured disparity [left, Window size = 13]');
subplot(2,5,5); plot(disparity_left_21); title('Measured disparity [left, Window size = 21]');

subplot(2,5,6); plot(gt_vec1); title('Ground Truth [right]');
subplot(2,5,7); plot(disparity_right_3); title('Measured disparity [right, Window size = 3]');
subplot(2,5,8); plot(disparity_right_7); title('Measured disparity [right, Window size = 7]');
subplot(2,5,9); plot(disparity_right_13); title('Measured disparity [right, Window size = 13]');
subplot(2,5,10); plot(disparity_right_21); title('Measured disparity [right, Window size = 21]');


%% NCC

disparity_left_3 = ncc(im1,im0,3,disp_threshold,row);
disparity_right_3 = ncc(im0,im1,3,disp_threshold,row);
disparity_left_7 = ncc(im1,im0,7,disp_threshold,row);
disparity_right_7 = ncc(im0,im1,7,disp_threshold,row);
disparity_left_13 = ncc(im1,im0,13,disp_threshold,row);
disparity_right_13 = ncc(im0,im1,13,disp_threshold,row);
disparity_left_21 = ncc(im1,im0,21,disp_threshold,row);
disparity_right_21 = ncc(im0,im1,21,disp_threshold,row);

figure(3);
set(gca, 'PlotBoxAspectRatio', [1 0.3 1]);
subplot(2,5,1); plot(gt_vec0); title('Ground Truth [left]');
subplot(2,5,2); plot(disparity_left_3); title('Measured disparity [left, Window size = 3]');
subplot(2,5,3); plot(disparity_left_7); title('Measured disparity [left, Window size = 7]');
subplot(2,5,4); plot(disparity_left_13); title('Measured disparity [left, Window size = 13]');
subplot(2,5,5); plot(disparity_left_21); title('Measured disparity [left, Window size = 21]');

subplot(2,5,6); plot(gt_vec1); title('Ground Truth [right]');
subplot(2,5,7); plot(disparity_right_3); title('Measured disparity [right, Window size = 3]');
subplot(2,5,8); plot(disparity_right_7); title('Measured disparity [right, Window size = 7]');
subplot(2,5,9); plot(disparity_right_13); title('Measured disparity [right, Window size = 13]');
subplot(2,5,10); plot(disparity_right_21); title('Measured disparity [right, Window size = 21]');