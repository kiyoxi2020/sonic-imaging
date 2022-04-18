clear
close all
%% load velocity model
load vmodel.mat % vmodel:速度模型， x:地表空间采样点，z：地下深度采样点
h=figure;
imagesc(vmodel);c=colorbar;
[z_size, x_size] = size(vmodel);
set(gca,'XTick',[1:20:x_size]);
set(gca,'XTickLabel',x(1:20:x_size));
xlabel('地表位置（m）');
set(gca,'YTick',[1:20:z_size]);
set(gca,'YTickLabel',z(1:20:z_size));
ylabel('深度（m）');
c.Label.String = '速度（m/s）';c.Label.FontSize = 12;
title('地下速度模型');
saveas(h,'vmodel.png');
%% wave propagation
dx = x(2)-x(1);             % 空间采样间隔（米）
dtstep=0.001;               % 声波接收器接收采样率（秒）
dt=0.001;                   % 成像数据时间采样率（秒）
tmax=1;                     % 声波接收器最长接收时间（秒）
xrec=x;                     % 声波接收器位置（横坐标）
zrec=zeros(size(xrec));     % 声波接收器位置（纵坐标）
snap1=zeros(size(vmodel));  % 初始波场数据，可以理解为时刻0的波场
snap1(1,length(x)/2)=1;     % 声波发生器的初始数据，可以理解为时刻1的波场
% 有限差分过程
[seismogram, seis, t] = shotrec(dx, dtstep, dt, tmax, ...
    vmodel, snap1, xrec, zrec, [5,10,30,40],0);
%% 波场显示
[t_size, x_size] = size(seismogram);
h=figure;set(gcf,'position',[100,100,1020,520]);
subplot(1,2,1);
imagesc(seis,[-0.01,0.01]);colormap gray;colorbar;
set(gca,'XTick',[1:20:x_size]);
set(gca,'XTickLabel',x(1:10:x_size));
xlabel('地表位置（m）');
set(gca,'YTick',[1:100:t_size]);
set(gca,'YTickLabel',t(1:100:t_size)*1000);
ylabel('时间（ms）');
title('声波接收器接收波场数据（滤波前）');
subplot(1,2,2);
imagesc(seismogram,[-0.01,0.01]);colormap gray;colorbar;
set(gca,'XTick',[1:20:x_size]);
set(gca,'XTickLabel',x(1:10:x_size));
xlabel('地表位置（m）');
set(gca,'YTick',[1:100:t_size]);
set(gca,'YTickLabel',t(1:100:t_size)*1000);
ylabel('时间（ms）');
title('声波接收器接收波场数据（滤波后）');
saveas(h,'seis.png');


