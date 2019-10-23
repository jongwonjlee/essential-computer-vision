clear all;
close all;

%% Step 0: Load image and GUI preperation
% Load an image to matlab workspace

fig = figure;
img = imread('pattern.png');
imshow(img);

% Enable data cursor mode
datacursormode on;
dcm_obj = datacursormode(fig);

%% Step 1:  Determine a vanishing line: Counterclockwisely click four points which form a "square" on the ground plane.
disp('Step 1: Determine points on the checkboard: Pinpoint the points (4,0,0),(0,4,0),(0,0,4),(4,4,0),(0,4,4),(4,0,4),and (0,0,0), then press "Esc" to return')
pause

num_pts = 7;

% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);

% Construct matrices of image points and world points. Point are represented by
% homogeneous coordinate.
for i=1:num_pts
    image_points(i,:) = info_struct(num_pts+1-i).Position;
end


world_points = [4 0 0; 0 4 0; 0 0 4; 4 4 0; 0 4 4; 4 0 4; 0 0 0]*0.12;

image_points(:,3) = 1;
world_points(:,4) = 1;

image_points = transpose(image_points);
world_points = transpose(world_points);

%% Step 2: Calculate the transformation matrix P
A = zeros(2*num_pts, 12);

zero_mtx = zeros(1,4);
xX = image_points(1,:).*world_points;
yX = image_points(2,:).*world_points;
wX = image_points(3,:).*world_points;

for i=1:num_pts
   A(2*i-1:2*i,:) = [wX(:,i)'  zero_mtx -xX(:,i)';
                     zero_mtx wX(:,i)' -yX(:,i)'];
end

% Find p, which consists of the transformation matrix P. p = argmin(Ap), norm(p) = 1
[U,S,V] = svd(A);
p = V(:,12);
P = reshape(p,4,3)';

% %% image data normalization
% mean_image_points = mean(image_points');
% dist_sum_1 = 0;
% for i = 1:num_pts
%     dist_sum_1 = dist_sum_1 + norm(image_points(:,i) - mean_image_points')^2;
% end
% scale_1 = sqrt(dist_sum_1/2/num_pts);
% T_image = [         1/scale_1,           0      ,  -1/scale_1*mean_image_points(1);
%                         0,        1/scale_1     ,  -1/scale_1*mean_image_points(2);
%                         0,               0      ,                                1];
% norm_image_points = T_image *image_points;
% 
% %% world data normalization
% mean_world_points = mean(world_points');
% dist_sum_2 = 0;
% for i = 1:num_pts
%     dist_sum_2 = dist_sum_2 + norm(world_points(:,i) - mean_world_points')^2;
% end
% scale_2 = sqrt(dist_sum_2/2/num_pts);
% T_world = [         1/scale_2,           0      ,           0      ,  -1/scale_2*mean_world_points(1);
%                         0,        1/scale_2     ,           0      ,  -1/scale_2*mean_world_points(2);
%                         0,               0      ,     1/scale_2    ,  -1/scale_2*mean_world_points(2);
%                         0,               0      ,           0      ,                                 1];
% norm_world_points = T_world *world_points;

%P_ori = inv(T_image)*P*T_world;

%% Step 3: Find intrinsic and extrinsic parameters

% C is a null space of P; PC = 0
C = null(P);
C0 = C/C(4);

%P = M*[eye(3) C0] = [M MC0], M = 3 by 3, C0 = 3 by 1
M = P(1:3,1:3);

% K and R are results of RQ decomposition of M.
[Rinv Kinv] = qr(inv(M));
R = inv(Rinv);
K_raw = inv(Kinv);

% normalize K so that the element at (3,3) become one.
K = K_raw/K_raw(3,3);
t = inv(K_raw)*P(:,4); % t can be calculated by either above or -R*C0(1:3)

fprintf("Results: \n");
R
t
camera_pos = -inv(R) * t