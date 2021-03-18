
%% plot original signal graphs
figure(1)
subplot(1, 2, 1)
[y, Fs] = audioread('GNR.m4a');
tr_gnr = length(y) / Fs;
plot((1:length(y))/ Fs, y)
xlabel('Time [sec]')
ylabel('Amplitude')
title('Sweet Child O Mine')

subplot(1, 2, 2)
[y, Fs] = audioread('Floyd.m4a');
tr_fld = length(y) / Fs;
plot((1:length(y))/ Fs, y)
xlabel('Time [sec]')
ylabel('Amplitude')
title('Comfortably Numb')
%% GNR
[y, Fs] = audioread('GNR.m4a');
tr_gnr = length(y)/Fs;
y = y';

st = fft(y);
n = length(y);
L = tr_gnr;
t2 = linspace(0, L, n+1);
t = t2(1:n);
k = (1/L) * [0:n/2-1 -n/2:-1];
ks = fftshift(k);

figure(2)
subplot(2, 1, 1)
plot(t, y, 'k', 'Linewidth', 2)
set(gca, 'Fontsize', 16); xlabel('time(t)'); ylabel('s(t)')

subplot(2, 1, 2)
plot(ks, abs(fftshift(st))/max(abs(st)), 'r', 'Linewidth', 2); 
set(gca, 'Fontsize', 16); xlabel('frequency(k)'); ylabel('fft(s)')

a = 1000;
tau = 0:0.1:L;

for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2);
   Sg = g.*y;
   Sgt = fft(Sg);
   
   figure(3)
   subplot(3,1,1) % Time domain
    plot(t,y,'k','Linewidth',2)
    hold on
    plot(t,g,'m','Linewidth',2)
    set(gca,'Fontsize',16), xlabel('time (t)'), ylabel('S(t)')

    subplot(3,1,2) % Time domain
    plot(t,Sg,'k','Linewidth',2)
    set(gca,'Fontsize',16,'ylim',[-1 1]), xlabel('time (t)'), ylabel('S(t)*g(t-\tau)')

    subplot(3,1,3) % Fourier domain
    plot(ks,abs(fftshift(Sgt))/max(abs(Sgt)),'r','Linewidth',2);
    set(gca,'Fontsize',16), xlabel('frequency (k)'), ylabel('fft(S(t)*g(t-\tau))')
    drawnow
    pause(0.1)
    clf
end

a = 1000;
tau = 0:0.1:L;

for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); 
   Sg = g.*y;
   Sgt = fft(Sg);
   Sgt_spec(:,j) = fftshift(abs(Sgt)); 
end

figure(4)
pcolor(tau,ks,Sgt_spec)
shading interp
set(gca,'ylim',[0 4000],'Fontsize',16)
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (k)')


%% Floyd
[y, Fs] = audioread('Floyd.m4a');
tr_fld = length(y)/Fs;
y = y(1:length(y) - 1);
y = y';

st = fft(y);
n = length(y);
L = tr_fld;
t2 = linspace(0, L, n+1);
t = t2(1:n);
k = (1/L) * [0:n/2-1 -n/2:-1];
ks = fftshift(k);

figure(3)
subplot(4, 1, 1)
plot(t, y, 'k', 'Linewidth', 2)
set(gca, 'Fontsize', 16); xlabel('time(t)'); ylabel('s(t)')

subplot(4, 1, 2)
plot(ks, abs(fftshift(st))/max(abs(st)), 'r', 'Linewidth', 2); 
set(gca, 'Fontsize', 16); xlabel('frequency(k)'); ylabel('fft(s)')

a = 1000;
tau = 0:1:L;

for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); 
   Sg = g.*y;
   Sgt = fft(Sg);
   
   figure(4)
   subplot(5,1,1) % Time domain
    plot(t,y,'k','Linewidth',2)
    hold on
    plot(t,g,'m','Linewidth',2)
    set(gca,'Fontsize',16), xlabel('time (t)'), ylabel('S(t)')

    subplot(5,1,2) % Time domain
    plot(t,Sg,'k','Linewidth',2)
    set(gca,'Fontsize',16,'ylim',[-1 1]), xlabel('time (t)'), ylabel('S(t)*g(t-\tau)')

    subplot(5,1,3) % Fourier domain
    plot(ks,abs(fftshift(Sgt))/max(abs(Sgt)),'r','Linewidth',2);
    set(gca,'Fontsize',16), xlabel('frequency (k)'), ylabel('fft(S(t)*g(t-\tau))')
    drawnow
    pause(0.1)
    clf
end

a = 1000;
tau = 0:1:L;

for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); 
   Sg = g.*y;
   Sgt = fft(Sg);
   Sgt_spec(:,j) = fftshift(abs(Sgt)); 
end

figure(5)
pcolor(tau,ks,Sgt_spec)
shading interp
set(gca,'ylim',[0 4000],'Fontsize',16)
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (k)')