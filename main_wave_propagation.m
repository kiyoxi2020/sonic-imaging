clear
close all
%% load velocity model
load vmodel.mat % vmodel:�ٶ�ģ�ͣ� x:�ر�ռ�����㣬z��������Ȳ�����
h=figure;
imagesc(vmodel);c=colorbar;
[z_size, x_size] = size(vmodel);
set(gca,'XTick',[1:20:x_size]);
set(gca,'XTickLabel',x(1:20:x_size));
xlabel('�ر�λ�ã�m��');
set(gca,'YTick',[1:20:z_size]);
set(gca,'YTickLabel',z(1:20:z_size));
ylabel('��ȣ�m��');
c.Label.String = '�ٶȣ�m/s��';c.Label.FontSize = 12;
title('�����ٶ�ģ��');
saveas(h,'vmodel.png');
%% wave propagation
dx = x(2)-x(1);             % �ռ����������ף�
dtstep=0.001;               % �������������ղ����ʣ��룩
dt=0.001;                   % ��������ʱ������ʣ��룩
tmax=1;                     % ���������������ʱ�䣨�룩
xrec=x;                     % ����������λ�ã������꣩
zrec=zeros(size(xrec));     % ����������λ�ã������꣩
snap1=zeros(size(vmodel));  % ��ʼ�������ݣ��������Ϊʱ��0�Ĳ���
snap1(1,length(x)/2)=1;     % �����������ĳ�ʼ���ݣ��������Ϊʱ��1�Ĳ���
% ���޲�ֹ���
[seismogram, seis, t] = shotrec(dx, dtstep, dt, tmax, ...
    vmodel, snap1, xrec, zrec, [5,10,30,40],0);
%% ������ʾ
[t_size, x_size] = size(seismogram);
h=figure;set(gcf,'position',[100,100,1020,520]);
subplot(1,2,1);
imagesc(seis,[-0.01,0.01]);colormap gray;colorbar;
set(gca,'XTick',[1:20:x_size]);
set(gca,'XTickLabel',x(1:10:x_size));
xlabel('�ر�λ�ã�m��');
set(gca,'YTick',[1:100:t_size]);
set(gca,'YTickLabel',t(1:100:t_size)*1000);
ylabel('ʱ�䣨ms��');
title('�������������ղ������ݣ��˲�ǰ��');
subplot(1,2,2);
imagesc(seismogram,[-0.01,0.01]);colormap gray;colorbar;
set(gca,'XTick',[1:20:x_size]);
set(gca,'XTickLabel',x(1:10:x_size));
xlabel('�ر�λ�ã�m��');
set(gca,'YTick',[1:100:t_size]);
set(gca,'YTickLabel',t(1:100:t_size)*1000);
ylabel('ʱ�䣨ms��');
title('�������������ղ������ݣ��˲���');
saveas(h,'seis.png');


