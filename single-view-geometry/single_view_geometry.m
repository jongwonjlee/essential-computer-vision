m% Load an image to matlab workspace
fig = figure;
img = imread('hutme_ref.png');
imshow(img);

% Enable data cursor mode
datacursormode on;
dcm_obj = datacursormode(fig);

%% Step 1:  Determine a vanishing line: Counterclockwisely click four points which form a "square" on the ground plane.
disp('Step 1: Determine a vanishing line: Counterclockwisely click four points which form a "square" on the ground plane, then press "Esc" to return')
pause 
% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);
for i=1:4
    groundplane(i,:) = info_struct(i).Position;
end
groundplane(:,3) = 1;
% Calculate the vanishing line of the ground plane.
for i=1:4
    lines(i,:) = cross(groundplane(mod(i,4)+1,:),groundplane(mod(i+1,4)+1,:));
end
for i=1:2
    vanishingpoints(i,:) = cross(lines(i,:),lines(i+2,:));
    vanishingpoints(i,:) = vanishingpoints(i,:)/vanishingpoints(i,3); % homogeneous coordinate
end
vx = vanishingpoints(1,:);
vy = vanishingpoints(2,:);

% Enable data cursor mode
close all;
fig = figure;
imshow(img);
line([vx(1) vy(1)],[vx(2) vy(2)], 'Color','white','LineWidth', 2);

datacursormode on;
dcm_obj = datacursormode(fig);

%% Step 2: Determine a vanishing point: Counterclockwisely click four points which form a vertically parrelel line.
disp('Step 2: Counterclockwisely click four points which form a vertically parrelel line, then press "Esc" to return')
pause
% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);

for i=1:4
p(i,1:2) = info_struct(i).Position;
p(i,3) = 1;
end

vz = cross(cross(p(1,:),p(2,:)),cross(p(3,:),p(4,:)));
vz = vz/vz(3);


% Enable data cursor mode
close all;
fig = figure;
imshow(img);
line([vx(1) vy(1)],[vx(2) vy(2)], 'Color','white','LineWidth', 2);

datacursormode on;
dcm_obj = datacursormode(fig);


%% Step 3: Specify r, b, t0, and b0 respectively.
disp('Step 3: Click r, b, t0, and b0 respectively, then press "Esc" to return')
pause
% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);

r = info_struct(1).Position;
b = info_struct(2).Position;
t0  = info_struct(3).Position;
b0 = info_struct(4).Position;

r(3) = 1; b(3) = 1; t0(3) = 1; b0(3) = 1; 

line([t0(1) b0(1)],[t0(2) b0(2)], 'Color','red','LineWidth', 2);

%% Step 4: Calculate the height of object H = t0_b0.

v = cross(cross(b,b0), cross(vx,vy));
v = v/v(3);
t = cross(cross(b,r), cross(v,t0));
t = t/t(3);

line([b(1) vz(1)],[b(2) vz(2)], 'Color','white','LineWidth', 2);
line([b0(1) vz(1)],[b0(2) vz(2)], 'Color','white','LineWidth', 2);

R = 201;
H = R*(norm(t-b)*norm(vz-r))/(norm(r-b)*norm(vz-t));

fprintf("Measured height: %f\n", H);