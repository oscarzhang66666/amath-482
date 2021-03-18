%set up for and find the energy of single values
X = VideoReader('ski_drop_low.mp4');
video = [];
while hasFrame(X)
    data = readFrame(X);
    data = rgb2gray(data);
    data = data(:);
    video = [video data];
end
video = double(video);

dt = 1 / X.FrameRate;
height = X.height;
width = X.width;

X1 = video(:, 1:end-1);
X2 = video(:, 2:end);
frame = size(video, 2) - 1;
[U, S, V] = svd(X1, 'econ');
plot(diag(S)/sum(diag(S)), 'ro');
xlabel('single values')
ylabel('energy captured')
%% compute the DMD mode
r = 1;
Ur = U(:, 1:r);
Sr = S(1:r, 1:r);
Vr = V(:, 1:r);

Atilde = Ur'*X2*Vr / Sr;
[W, D] = eig(Atilde);
Phi = X2*Vr/ Sr*W;
lambda = diag(D);
omega = log(lambda) / dt;
[val, ind] = sort(abs(omega));

omega = omega(ind(1));
%% based on the DMD mode, compute the Sparse DMD and low-rank DMD
t = linspace(0, X.Duration, size(video, 2));
x1 = video(:, 1);
b = Phi\x1;
time_dynamics = zeros(r,length(t));
for iter = 1:length(t)
    temp = (b.*(exp(omega*t(iter))).');
    time_dynamics(:,iter) = sum(temp, 2);
end

X_lowRank = Phi*time_dynamics;
X_sparse = video - abs(X_lowRank);

R = zeros(length(X_sparse), size(X_sparse, 2));

X_fg = X_sparse - R;
X_bg = abs(X_lowRank) + R;

video_bg = reshape(X_bg, [height, width, frame+1]);
video_fg = reshape(X_fg, [height, width, frame+1]);
%% plot results
i = 100;
figure(1)
subplot(3,3,1);
pcolor(flip(reshape(video(:,i), [height, width]))); shading interp; colormap(gray);axis off;
title('Original film at frame = 100');
subplot(3,3,2);
pcolor(flip(video_bg(:,:,i))); shading interp; colormap(gray);axis off;
title('background at frame = 100');
subplot(3,3,3);
pcolor(flip(video_fg(:,:,i))); shading interp; colormap(gray);axis off;
title('foreground at frame = 100');
%%
i = 150;
subplot(3,3,4);
pcolor(flip(reshape(video(:,i), [height, width]))); shading interp; colormap(gray);axis off;
title('Original film at frame = 100');
subplot(3,3,5);
pcolor(flip(video_bg(:,:,i))); shading interp; colormap(gray);axis off;
title('background at frame = 150');
subplot(3,3,6);
pcolor(flip(video_fg(:,:,i))); shading interp; colormap(gray);axis off;
title('foreground at frame = 150');
%%
i = 200;
subplot(3,3,7);
pcolor(flip(reshape(video(:,i), [height, width]))); shading interp; colormap(gray);axis off;
title('Original film at frame = 100');
subplot(3,3,8);
pcolor(flip(video_bg(:,:,i))); shading interp; colormap(gray);axis off;
title('background at frame = 200');
subplot(3,3,9);
pcolor(flip(video_fg(:,:,i))); shading interp; colormap(gray);axis off;
title('foreground at frame = 200');
