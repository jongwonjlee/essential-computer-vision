clear all;
close all;

%% Step 0: Load image and GUI preperation
% Load an image to matlab workspace

fig1 = figure(1);
img1 = imread('h1_img1.jpg');
imshow(img1);

fig2 = figure(2);
img2 = imread('h1_img2.jpg');
imshow(img2);


% Enable data cursor mode
datacursormode on;
dcm_obj1 = datacursormode(fig1);
dcm_obj2 = datacursormode(fig2);

%% Step 1:  Determine six pairs of corresponding points on the facade of the building. Each pair should be selected in the same order.
disp('Step 1: Determine six pairs of corresponding points on the facade of the building. Each pair should be selected in the same order. Then press "Esc" to return')
pause

num_pts = 6;

% Export cursor to workspace
info_struct1 = getCursorInfo(dcm_obj1);
info_struct2 = getCursorInfo(dcm_obj2);

%Construct matrices of image points and world points. Point are represented by
%homogeneous coordinate.

for i=1:num_pts
    image1_points(i,:) = info_struct1(num_pts+1-i).Position;
    image2_points(i,:) = info_struct2(num_pts+1-i).Position;
end

image1_points(:,3) = 1;
image2_points(:,3) = 1;

image1_points = transpose(image1_points);
image2_points = transpose(image2_points);

%% Step 2: Calculate the transformation matrix H
A = zeros(2*num_pts, 9);

zero_mtx = zeros(1,3);
xX = image2_points(1,:).*image1_points;
yX = image2_points(2,:).*image1_points;
wX = image2_points(3,:).*image1_points;

for i=1:num_pts
   A(2*i-1:2*i,:) = [wX(:,i)'  zero_mtx -xX(:,i)';
                     zero_mtx wX(:,i)' -yX(:,i)'];
end

%Find h, which consists of the transformation matrix H. h = argmin(Ah), norm(h) = 1
[U,S,V] = svd(A);
h = V(:,9);
H = reshape(h,3,3)';


%% Step 3: Apply homography H on image 1 and warp it to image 2.
figure(3);
T = maketform('projective',H');
imOut = imtransform(img1,T);
imshow(imOut);