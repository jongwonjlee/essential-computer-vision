clear all;
close all;

%% Step 0: Load image and GUI preperation
% Load an image to matlab workspace

fig1 = figure(1);
img1 = imread('f_img1.jpg');
imshow(img1);

fig2 = figure(2);
img2 = imread('f_img2.jpg');
imshow(img2);


% Enable data cursor mode
datacursormode on;
dcm_obj1 = datacursormode(fig1);
dcm_obj2 = datacursormode(fig2);


%% Step 1:  Determine thirty pairs of corresponding points on the building. Each pair should be selected in the same order.
disp('Step 1: Determine thirty pairs of corresponding points on the building. Each pair should be selected in the same order. Then press "Esc" to return')
pause

num_pts = 30;

% Export cursor to workspaceG
info_struct1 = getCursorInfo(dcm_obj1);
info_struct2 = getCursorInfo(dcm_obj2);

%Construct matrices of image points and world points. Points are represented by
%homogeneous coordinate.

for i=1:num_pts
    x1(i,:) = info_struct1(num_pts+1-i).Position;
    x2(i,:) = info_struct2(num_pts+1-i).Position;
end

x1(:,3) = 1;
x2(:,3) = 1;

x1 = transpose(x1);
x2 = transpose(x2);


%% Step 1-1: Normalize points 

[x1_hat, T1] = normalise2dpts(x1);
[x2_hat, T2] = normalise2dpts(x2);


%% Step 2: Build the constraint matrix A, and calculate the fundamental matrix F

A = [x2_hat(1,:)'.*x1_hat(1,:)' x2_hat(1,:)'.*x1_hat(2 ,:)' x2_hat(1,:)' ...
    x2_hat(2,:)'.*x1_hat(1,:)' x2_hat(2,:)'.*x1_hat(2,:)' x2_hat(2,:)' ...
    x1_hat(1,:)' x1_hat(2,:)' ones(num_pts,1)];

% Extract fundamental matrix from the column of V
% corresponding to the smallest singular value.
[U,S,V] = svd(A);
f = V(:,9);
F_hat = reshape(f,3,3)';

% Enforce rank2 constraint
[U,D,V] = svd(F_hat);
F_hat = U*diag([D(1,1) D(2,2) 0])*V';

%% Step 2-1: Denormalize the results
F = T2'*F_hat*T1;
% x1 = inv(T1)*x1_hat;
% x2 = inv(T2)*x2_hat;


%% Step 3: Draw epipolar lines in image img2 corresponding to the points in image img1

figure(3); %% Figure that img3 is drawn on
subplot(1,2,1);
imshow(img1);
title('Points and their corresponding epipolar lines in First Image'); hold on;

for i=1:num_pts
    plot(x1(1,i),x1(2,i),'go');
    text(x1(1,i),x1(2,i), num2str(i),'FontSize',10,'FontWeight','bold','Color','r');
end
epiLines1 = epipolarLine(F',x2(1:2,:)'); % Draw epipolar lines in image img1 corresponding to the points(x2(1:2,:)') in image img2
points1 = lineToBorderPoints(epiLines1,size(img1)); % Set boarder points which satisfies with the epipolar lines above
line(points1(:,[1,3])',points1(:,[2,4])', 'LineWidth', 1); % Drwaw them on img1


subplot(1,2,2);
imshow(img2);
title('Points and their corresponding epipolar lines in Second Image'); hold on;
for i=1:num_pts
    plot(x2(1,i),x2(2,i),'go');
    text(x2(1,i),x2(2,i), num2str(i),'FontSize',10,'FontWeight','bold','Color','r');
end
epiLines2 = epipolarLine(F,x1(1:2,:)'); % Draw epipolar lines in image img2 corresponding to the points(x1(1:2,:)') in image img1
points2 = lineToBorderPoints(epiLines2,size(img2)); % Set boarder points which satisfies with the epipolar lines above
line(points2(:,[1,3])',points2(:,[2,4])', 'LineWidth', 1); % Drwaw them on img2
truesize;