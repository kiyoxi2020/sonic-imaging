clear
close all
%% load velocity model
% load vmodel.mat 
% vmodel:速度模型， x:地表空间采样点，z:地下深度采样点，vlow:低频速度模型
% dt:时间采样率，dtstep:检波器采样率
velocity = [2000,2800,3200,3600];
layer = [0.3,0.6,0.8,1];
h=500;w=500;dx=2;
vmodel=ones(h,w)*velocity(1);
for i=1:1:length(layer)-1
    vmodel(round(h*layer(i)):round(h*layer(i+1)),:)=velocity(i+1);
end
x=[0:1:w-1]*dx;
z=[0:1:h-1]*dx;
dt=0.004;dtstep=0.0002;tmax=1;
vlow = ones(tmax/dt+1,w)*velocity(1);
%%
h=figure;
imagesc(vmodel);c=colorbar;
[z_size, x_size] = size(vmodel);
set(gca,'XTick',[1:round(x_size/5):x_size]);
set(gca,'XTickLabel',x(1:round(x_size/5):x_size));
xlabel('地表位置（m）');
set(gca,'YTick',[1:round(z_size/5):z_size]);
set(gca,'YTickLabel',z(1:round(z_size/5):z_size));
ylabel('深度（m）');
c.Label.String = '速度（m/s）';c.Label.FontSize = 12;
title('地下速度模型');
saveas(h,'vmodel.png');
h=figure;
imagesc(vlow);c=colorbar;
[t_size, x_size] = size(vlow);
t = [0:1:t_size-1]*dt*1000;
set(gca,'XTick',[1:round(x_size/5):x_size]);
set(gca,'XTickLabel',x(1:round(x_size/5):x_size));
xlabel('地表位置（m）');
set(gca,'YTick',[1:round(t_size/5):t_size]);
set(gca,'YTickLabel',t(1:round(t_size/5):t_size));
ylabel('时间（ms）');
c.Label.String = '速度（m/s）';c.Label.FontSize = 12;
title('低频速度模型');
saveas(h,'vlow.png');
%% wave propagation
vel = vmodel;
nshots=11;
fdom=30;
[w,tw]=wavemin(dt,fdom,.2);%source waveform
[shots,t,xshots,xrecs,shotnames]=afd_shootline(dx,vel,dt,dtstep,w,tw,tmax,nshots);
save(['vmodel_shots',num2str(nshots),'.mat'], 'shots', 't', 'xshots', 'xrecs', 'shotnames');
%%
h=figure;
for i = 1:1:nshots
    imagesc(shots{i},[-0.0001,0.0001]);colormap gray;
    title(['shots:',num2str(i)]);
    saveas(h,['shots-',num2str(i),'.png'])
    pause(0.01);
end
%% 预处理：滤除不需要的声波信号
load(['vmodel_shots',num2str(nshots),'.mat'])
xoffref=500;             % 设置滤波参考偏移距
xmute=[0 xoffref];       % 滤波偏移距范围
tmute0=.22;              % 零偏移距位置的滤波时间点
tmute1=.4;               % 参考偏移距位置的滤波时间点
tmute=[tmute0 tmute1];   % 滤波偏移距范围对应的时间范围
shotsg=preprocess_seis(shots,t,xrecs,xshots,xmute,tmute);
h=figure;
for i = 1:1:nshots
    imagesc(shotsg{i},[-0.0001,0.0001]);colormap gray;
    title(['shots:',num2str(i)]);
    pause(0.01);
end
%% 叠加成像
dxrecs=abs(xrecs{1}(2)-xrecs{1}(1));    % 声波接收器间隔
dxcmp=dxrecs/2;                         % cmp（共中心点道集）间隔
x0cmp=x(1);                             % 第一个cmp位置
x1cmp=x(end);                           % 最后一个cmp位置
cmp=[dxcmp x0cmp x1cmp]; 
stack=compute_cmpstack(shotsg,t,xrecs,xshots,cmp,vlow,x);
%%
h=figure;set(gcf,'position',[100,100,1500,520]);
ax1=subplot(1,2,1);
colormap(ax1,'parula');
imagesc(vmodel);c=colorbar;
[z_size, x_size] = size(vmodel);
set(ax1,'XTick',[1:round(x_size/5):x_size]);
set(ax1,'XTickLabel',x(1:round(x_size/5):x_size));
xlabel('地表位置（m）');
set(ax1,'YTick',[1:round(z_size/5):z_size]);
set(ax1,'YTickLabel',z(1:round(z_size/5):z_size));
ylabel('深度（m）');
c.Label.String = '速度（m/s）';c.Label.FontSize = 12;
title('地下速度模型');
ax2=subplot(1,2,2);
gca2=imagesc(stack);c=colorbar;
[z_size, x_size] = size(stack);
x=[0:1:x_size]*dxcmp;
set(gca,'XTick',[1:round(x_size/5):x_size]);
set(gca,'XTickLabel',x(1,1:round(x_size/5):x_size));
xlabel('地表位置（m）');
set(gca,'YTick',[1:round(z_size/5):z_size]);
set(gca,'YTickLabel',t(1:round(z_size/5):z_size));
colormap(ax2,'gray');
ylabel('时间（s）');
c.Label.String = '反射强度';c.Label.FontSize = 12;
title('叠加成像结果');
saveas(h,'stack.png');
