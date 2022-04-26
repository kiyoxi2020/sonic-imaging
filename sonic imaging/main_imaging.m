clear
close all
%% load velocity model
% load vmodel.mat 
% vmodel:�ٶ�ģ�ͣ� x:�ر�ռ�����㣬z:������Ȳ����㣬vlow:��Ƶ�ٶ�ģ��
% dt:ʱ������ʣ�dtstep:�첨��������
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
xlabel('�ر�λ�ã�m��');
set(gca,'YTick',[1:round(z_size/5):z_size]);
set(gca,'YTickLabel',z(1:round(z_size/5):z_size));
ylabel('��ȣ�m��');
c.Label.String = '�ٶȣ�m/s��';c.Label.FontSize = 12;
title('�����ٶ�ģ��');
saveas(h,'vmodel.png');
h=figure;
imagesc(vlow);c=colorbar;
[t_size, x_size] = size(vlow);
t = [0:1:t_size-1]*dt*1000;
set(gca,'XTick',[1:round(x_size/5):x_size]);
set(gca,'XTickLabel',x(1:round(x_size/5):x_size));
xlabel('�ر�λ�ã�m��');
set(gca,'YTick',[1:round(t_size/5):t_size]);
set(gca,'YTickLabel',t(1:round(t_size/5):t_size));
ylabel('ʱ�䣨ms��');
c.Label.String = '�ٶȣ�m/s��';c.Label.FontSize = 12;
title('��Ƶ�ٶ�ģ��');
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
%% Ԥ�����˳�����Ҫ�������ź�
load(['vmodel_shots',num2str(nshots),'.mat'])
xoffref=500;             % �����˲��ο�ƫ�ƾ�
xmute=[0 xoffref];       % �˲�ƫ�ƾ෶Χ
tmute0=.22;              % ��ƫ�ƾ�λ�õ��˲�ʱ���
tmute1=.4;               % �ο�ƫ�ƾ�λ�õ��˲�ʱ���
tmute=[tmute0 tmute1];   % �˲�ƫ�ƾ෶Χ��Ӧ��ʱ�䷶Χ
shotsg=preprocess_seis(shots,t,xrecs,xshots,xmute,tmute);
h=figure;
for i = 1:1:nshots
    imagesc(shotsg{i},[-0.0001,0.0001]);colormap gray;
    title(['shots:',num2str(i)]);
    pause(0.01);
end
%% ���ӳ���
dxrecs=abs(xrecs{1}(2)-xrecs{1}(1));    % �������������
dxcmp=dxrecs/2;                         % cmp�������ĵ���������
x0cmp=x(1);                             % ��һ��cmpλ��
x1cmp=x(end);                           % ���һ��cmpλ��
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
xlabel('�ر�λ�ã�m��');
set(ax1,'YTick',[1:round(z_size/5):z_size]);
set(ax1,'YTickLabel',z(1:round(z_size/5):z_size));
ylabel('��ȣ�m��');
c.Label.String = '�ٶȣ�m/s��';c.Label.FontSize = 12;
title('�����ٶ�ģ��');
ax2=subplot(1,2,2);
gca2=imagesc(stack);c=colorbar;
[z_size, x_size] = size(stack);
x=[0:1:x_size]*dxcmp;
set(gca,'XTick',[1:round(x_size/5):x_size]);
set(gca,'XTickLabel',x(1,1:round(x_size/5):x_size));
xlabel('�ر�λ�ã�m��');
set(gca,'YTick',[1:round(z_size/5):z_size]);
set(gca,'YTickLabel',t(1:round(z_size/5):z_size));
colormap(ax2,'gray');
ylabel('ʱ�䣨s��');
c.Label.String = '����ǿ��';c.Label.FontSize = 12;
title('���ӳ�����');
saveas(h,'stack.png');
