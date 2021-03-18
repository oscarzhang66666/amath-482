%% set up
load('cam1_1.mat')
load('cam2_1.mat')
load('cam3_1.mat')
load('cam1_2.mat')
load('cam2_2.mat')
load('cam3_2.mat')
load('cam1_3.mat')
load('cam2_3.mat')
load('cam3_3.mat')
load('cam1_4.mat')
load('cam2_4.mat')
load('cam3_4.mat')
%% case 1
camera11 = []; %% camera 1
numFrames1 = size(vidFrames1_1, 4);

for i = 1:numFrames1
    filter1 = zeros(480,640);
    filter1(170:430, 300:420) = 1;
    
    x1 = vidFrames1_1(:, :, :, i);
    x1 = rgb2gray(x1);
    x1 = double(x1);
    x1 = x1 .* filter1;
    
    indeces = find(x1 > max(x1(:)) * 0.95);
    [y, x] = ind2sub(size(x1), indeces);
    
    camera11 = [camera11; mean(x), mean(y)];
end

camera21 = []; %% camera 2
numFrames2 = size(vidFrames2_1, 4);

for i = 1:numFrames2
    filter2 = zeros(480, 640);
    filter2(100:400, 250:350) = 1;
    
    x2 = vidFrames2_1(:, :, :, i);
    x2 = rgb2gray(x2);
    x2 = double(x2);
    x2 = x2 .* filter2;
    
    indeces = find(x2 > max(x2(:)) * 0.95);
    [y, x] = ind2sub(size(x2), indeces);
    
    camera21 = [camera21; mean(x), mean(y)];
end


camera31 = []; %% camera 3
numFrames3 = size(vidFrames3_1, 4);

for i = 1:numFrames3
    filter3 = zeros(480, 640);
    filter3(240:340, 275:475) = 1;
    
    x3 = vidFrames3_1(:, :, :, i);
    x3 = rgb2gray(x3);
    x3 = double(x3);
    x3 = x3 .* filter3;
    
    indeces = find(x3 > max(x3(:)) * 0.95);
    [y, x] = ind2sub(size(x3), indeces);
    
    camera31 = [camera31; mean(x), mean(y)];
end


min_length = min([length(camera11); length(camera21); length(camera31)]);

camera11 = camera11(1:min_length, :);
camera21 = camera21(1:min_length, :);
camera31 = camera31(1:min_length, :);
data_total = [camera11'; camera21'; camera31'];
ave = mean(data_total, 2);

data_total = data_total - ave;

A = data_total' / sqrt(min_length - 1);
[U, S, V] = svd(A);
lamda = diag(S) .^ 2;
V = data_total' * V;

figure()
plot(lamda / sum(lamda), 'ro-', 'Linewidth', 2);
title('Test 1: Energy of diagonal variance');
xlabel('node');
ylabel('Energy captured');

figure()
subplot(2, 1, 1)
plot((1:min_length), data_total(1, :), (1:min_length), data_total(2, :), 'Linewidth', 2)
title('Test 1: Original displacement')
xlabel('frames')
ylabel('displacement')
legend('xy plane', 'z axis')

subplot(2, 1, 2)
plot((1:min_length), V(:, 1), (1:min_length), V(:, 2), (1:min_length), V(:, 3))
title('Test 1: Displacement across the principal component direction')
xlabel('frames')
ylabel('displacement')
legend('PC1', 'PC2', 'PC3')

%% case 2
camera12 = []; %% camera 1
numFrames1 = size(vidFrames1_2, 4);

for i = 1:numFrames1
    filter1 = zeros(480,640);
    filter1(200:420, 310:430) = 1;
    
    x1 = vidFrames1_2(:, :, :, i);
    x1 = rgb2gray(x1);
    x1 = double(x1);
    x1 = x1 .* filter1;
    
    indeces = find(x1 > max(x1(:)) * 0.95);
    [y, x] = ind2sub(size(x1), indeces);
    
    camera12 = [camera12; mean(x), mean(y)];
end

camera22 = []; %% camera 2
numFrames2 = size(vidFrames2_2, 4);

for i = 1:numFrames2
    filter2 = zeros(480, 640);
    filter2(80:420, 210:420) = 1;
    
    x2 = vidFrames2_2(:, :, :, i);
    x2 = rgb2gray(x2);
    x2 = double(x2);
    x2 = x2 .* filter2;
    
    indeces = find(x2 > max(x2(:)) * 0.95);
    [y, x] = ind2sub(size(x2), indeces);
    
    camera22 = [camera22; mean(x), mean(y)];
end


camera32 = []; %% camera 3
numFrames3 = size(vidFrames3_2, 4);

for i = 1:numFrames3
    filter3 = zeros(480, 640);
    filter3(200:340, 300:500) = 1;
    
    x3 = vidFrames3_2(:, :, :, i);
    x3 = rgb2gray(x3);
    x3 = double(x3);
    x3 = x3 .* filter3;
    
    indeces = find(x3 > max(x3(:)) * 0.95);
    [y, x] = ind2sub(size(x3), indeces);
    
    camera32 = [camera32; mean(x), mean(y)];
end

min_length = min([length(camera12); length(camera22); length(camera32)]);

camera12 = camera12(1:min_length, :);
camera22 = camera22(1:min_length, :);
camera32 = camera32(1:min_length, :);
data_total = [camera12'; camera22'; camera32'];
ave = mean(data_total, 2);

data_total = data_total - ave;

A = data_total' / sqrt(min_length - 1);
[U, S, V] = svd(A);
lamda = diag(S) .^ 2;
V = data_total' * V;

figure()
plot(lamda / sum(lamda), 'ro-', 'Linewidth', 2);
title('Test 2: Energy of diagonal variance');
xlabel('node');
ylabel('Energy captured');

figure()
subplot(2, 1, 1)
plot((1:min_length), data_total(1, :), (1:min_length), data_total(2, :), 'Linewidth', 2)
title('Test 2: Original displacement')
xlabel('frames')
ylabel('displacement')
legend('xy plane', 'z axis')

subplot(2, 1, 2)
plot((1:min_length), V(:, 1), (1:min_length), V(:, 2), (1:min_length), V(:, 3),(1:min_length), V(:, 4), (1:min_length), V(:, 5))
title('Test 2: Displacement across the principal component direction')
xlabel('frames')
ylabel('displacement')
legend('PC1', 'PC2', 'PC3', 'PC4', 'PC5')

%% case3
camera13 = []; %% camera 1
numFrames1 = size(vidFrames1_3, 4);

for i = 1:numFrames1
    filter1 = zeros(480,640);
    filter1(210:420, 280:400) = 1;
    
    x1 = vidFrames1_3(:, :, :, i);
    x1 = rgb2gray(x1);
    x1 = double(x1);
    x1 = x1 .* filter1;
    
    indeces = find(x1 > max(x1(:)) * 0.95);
    [y, x] = ind2sub(size(x1), indeces);
    
    camera13 = [camera13; mean(x), mean(y)];
end

camera23 = []; %% camera 2
numFrames2 = size(vidFrames2_3, 4);

for i = 1:numFrames2
    filter2 = zeros(480, 640);
    filter2(170:410, 195:420) = 1;
    
    x2 = vidFrames2_3(:, :, :, i);
    x2 = rgb2gray(x2);
    x2 = double(x2);
    x2 = x2 .* filter2;
    
    indeces = find(x2 > max(x2(:)) * 0.95);
    [y, x] = ind2sub(size(x2), indeces);
    
    camera23 = [camera23; mean(x), mean(y)];
end


camera33 = []; %% camera 3
numFrames3 = size(vidFrames3_3, 4);

for i = 1:numFrames3
    filter3 = zeros(480, 640);
    filter3(70:340, 270:470) = 1;
    
    x3 = vidFrames3_3(:, :, :, i);
    x3 = rgb2gray(x3);
    x3 = double(x3);
    x3 = x3 .* filter3;
    
    indeces = find(x3 > max(x3(:)) * 0.95);
    [y, x] = ind2sub(size(x3), indeces);
    
    camera33 = [camera33; mean(x), mean(y)];
end

min_length = min([length(camera13); length(camera23); length(camera33)]);

camera13 = camera13(1:min_length, :);
camera23 = camera23(1:min_length, :);
camera33 = camera33(1:min_length, :);
data_total = [camera13'; camera23'; camera33'];
ave = mean(data_total, 2);

data_total = data_total - ave;

A = data_total' / sqrt(min_length - 1);
[U, S, V] = svd(A);
lamda = diag(S) .^ 2;
V = data_total' * V;

figure()
plot(lamda / sum(lamda), 'ro-', 'Linewidth', 2);
title('Test 3: Energy of diagonal variance');
xlabel('node');
ylabel('Energy captured');

figure()
subplot(2, 1, 1)
plot((1:min_length), data_total(1, :), (1:min_length), data_total(2, :), 'Linewidth', 2)
title('Test 3: Original displacement')
xlabel('frames')
ylabel('displacement')
legend('xy plane', 'z axis')

subplot(2, 1, 2)
plot((1:min_length), V(:, 1), (1:min_length), V(:, 2), (1:min_length), V(:, 3),(1:min_length), V(:, 4))
title('Test 3: Displacement across the principal component direction')
xlabel('frames')
ylabel('displacement')
legend('PC1', 'PC2', 'PC3', 'PC4')

%% case 4
camera14 = []; %% camera 1
numFrames1 = size(vidFrames1_4, 4);

for i = 1:numFrames1
    filter1 = zeros(480,640);
    filter1(170:430, 300:400) = 1;
    
    x1 = vidFrames1_4(:, :, :, i);
    x1 = rgb2gray(x1);
    x1 = double(x1);
    x1 = x1 .* filter1;
    
    indeces = find(x1 > max(x1(:)) * 0.95);
    [y, x] = ind2sub(size(x1), indeces);
    
    camera14 = [camera14; mean(x), mean(y)];
end

camera24 = []; %% camera 2
numFrames2 = size(vidFrames2_4, 4);

for i = 1:numFrames2
    filter2 = zeros(480, 640);
    filter2(80:380, 250:350) = 1;
    
    x2 = vidFrames2_4(:, :, :, i);
    x2 = rgb2gray(x2);
    x2 = double(x2);
    x2 = x2 .* filter2;
    
    indeces = find(x2 > max(x2(:)) * 0.95);
    [y, x] = ind2sub(size(x2), indeces);
    
    camera24 = [camera24; mean(x), mean(y)];
end


camera34 = []; %% camera 3
numFrames3 = size(vidFrames3_4, 4);

for i = 1:numFrames3
    filter3 = zeros(480, 640);
    filter3(240:340, 265:485) = 1;
    
    x3 = vidFrames3_4(:, :, :, i);
    x3 = rgb2gray(x3);
    x3 = double(x3);
    x3 = x3 .* filter3;
    
    indeces = find(x3 > max(x3(:)) * 0.95);
    [y, x] = ind2sub(size(x3), indeces);
    
    camera34 = [camera34; mean(x), mean(y)];
end

min_length = min([length(camera14); length(camera24); length(camera34)]);

camera14 = camera14(1:min_length, :);
camera24 = camera24(1:min_length, :);
camera34 = camera34(1:min_length, :);
data_total = [camera14'; camera24'; camera34'];
ave = mean(data_total, 2);

data_total = data_total - ave;

A = data_total' / sqrt(min_length - 1);
[U, S, V] = svd(A);
lamda = diag(S) .^ 2;
V = data_total' * V;

figure()
plot(lamda / sum(lamda), 'ro-', 'Linewidth', 2);
title('Test 4: Energy of diagonal variance');
xlabel('node');
ylabel('Energy captured');

figure()
subplot(2, 1, 1)
plot((1:min_length), data_total(1, :), (1:min_length), data_total(2, :), 'Linewidth', 2)
title('Test 4: Original displacement')
xlabel('frames')
ylabel('displacement')
legend('xy plane', 'z axis')

subplot(2, 1, 2)
plot((1:min_length), V(:, 1), (1:min_length), V(:, 2), (1:min_length), V(:, 3))
title('Test 4: Displacement across the principal component direction')
xlabel('frames')
ylabel('displacement')
legend('PC1', 'PC2', 'PC3')