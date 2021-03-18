
load subdata.mat
% set up
L = 10;
n = 64;
x2 = linspace(-L,L,n+1); 
x = x2(1:n); 
y = x; 
z = x;

k = (2*pi/(2*L))*[0:(n/2 - 1) -n/2:-1]; 
ks = fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

 %for j = 1:49    
 %   Un(:,:,:)=reshape(subdata(:,j),n,n,n);
 %   M = max(abs(Un),[],'all');
 %   close all, isosurface(X,Y,Z,abs(Un)/M,0.7);
 %   axis([-20 20 -20 20 -20 20]), grid on, drawnow;
 %   pause(1);
 %end

% part 1
average =  zeros (n ,n ,n);

for j=1:49
    Un(:,:,:)=reshape(subdata(:,j),n,n,n); % reshape the data to demanded shape
    average = average + fftn(Un);
end

average = abs(fftshift(average)) ./49;
[maximum, index] = max(average(:)); % find out the maximum and its index

[xi,yi,zi] = ind2sub([n,n,n], index);
center_x = Kx(xi, yi, zi)
center_y = Ky(xi, yi, zi)
center_z = Kz(xi, yi, zi)

tau = 0.7;
filter = exp(-tau * ((Kx - center_x) .^ 2 + (Ky - center_y) .^ 2 + (Kz - center_z) .^ 2)); % set up filter function
filter = fftshift(filter);

path = zeros(49, 3);

for k = 1:49
    Un(:, :, :) = reshape(subdata(:, k), n, n, n); %reshape the data to demand shape
    Utn = fftn(Un);
    Unft = Utn .* filter;
    Unf = ifftn(Unft);
    
    [maximum_2, index_2] = max(Unf(:));
    [X_path, Y_path, Z_path] = ind2sub([n,n,n], index_2);
    x_path = X(X_path, Y_path, Z_path);
    y_path = Y(X_path, Y_path, Z_path);
    z_path = Z(X_path, Y_path, Z_path);
    
    path(k, 1) = x_path;
    path(k, 2) = y_path;
    path(k, 3) = z_path;
end
plot3(path(:,1), path(:,2), path(:,3), 'LineWidth', 2); grid on;
title('Path of the submarine');
xlabel('x'); ylabel('y'); zlabel('z');

final_location  = [path(49, 1), path(49, 2), path(49, 3)]