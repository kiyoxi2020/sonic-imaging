function [seismogram,seis,t]=shotrec(dx,dtstep,dt,tmax, ...
         model,snap1,xrec,zrec,filt,phase)
%%
% dx: 空间采样间隔，dtstep：声波接收器时间采样率
% dt：成像数据时间采样率，tmax：声波接收器最长接收时间
% model：速度模型，snap1：初始波场数据
% xrec：声波接收器横坐标位置，zrec：声波接收器纵坐标位置
% filt：滤波器
%%
velocity=model;                                         % 速度模型
[nz,~]=size(snap1);
nrec=length(xrec);                                      % 波场数据
seis=zeros(floor(tmax/dtstep),nrec);                    % 声波接收器坐标
ixrec=floor(xrec./dx)+1;
izrec=floor(zrec./dx)+1;
irec=(ixrec-1)*nz+izrec;
seis(1,:)=snap1(irec);                                  % 读取声波接收器位置的波场数据
maxstep=round(tmax/dtstep)-1;                           % 声波接收器时间采样步长
disp(['There are ' int2str(maxstep) ' steps to complete']);
time0=clock;
nwrite=2*round(maxstep/50)+1;
snap2=snap1;                                            % 时间t的波场
snap1=zeros(size(snap2));                               % 时间t-1的波场s
% h=figure;set(gcf,'position',[100,100,1500,520]);
% writerObj=VideoWriter('wave-propagation.avi');  %// 定义一个视频文件用来存动画
% writerObj.FrameRate = 60;
% open(writerObj);  
for k=1:1:maxstep
    snap0=snap2;
    snap2=compute_snap(dx,dtstep,velocity,snap1,snap2); % 有限差分更新t+1时刻波场
    snap1=snap0;
    pause(0.01);title([num2str(k),'/',num2str(maxstep)])
    seis(k+1,:)=snap2(irec);                            % 读取声波接收器位置的波场数据
    
    if rem(k,nwrite) == 0                               % 显示当前波场传播情况
        timenow=clock;
        tottime=etime(timenow,time0);
        timeperstep=tottime/k;
        timeleft=timeperstep*(maxstep-k);
        
        disp(['wavefield propagated to ' num2str(k*dtstep) ...
            ' s; computation time remaining ' ...
            num2str(timeleft) ' s']);
    end
    
    
%     subplot(1,2,1)
%     imagesc(filter2d_butter(snap2,dtstep,200),[-0.05,0.05]);colormap gray;title('声场传播过程')
%     subplot(1,2,2)
%     seis0=imresize(seis,[round(dtstep/dt*maxstep),nrec]);
%     imagesc(filter2d_butter(seis0,dt,50),[-0.05,0.05]);colormap gray;title('接收器接收信号')
%     pause(0.01);
%  A =  getframe(gcf);            %// 把图像存入视频文件中
%  writeVideo(writerObj,A); %// 将帧写入视频
 
end
%  close(writerObj);

%compute a time axis
t=((0:size(seis,1)-1)*dtstep)';
disp('modelling completed')

%filter
filt=[filt(2) filt(2)-filt(1) filt(3) filt(4)-filt(3)];
seismogram=zeros(size(seis));
disp('filtering...')
ifit=near(t,.9*max(t),max(t));
tpad=(max(t)+dt:dt:1.1*max(t))';
for k=1:nrec
    tmp=seis(:,k);
    cs=polyfit(t(ifit),tmp(ifit),1);
    tmp=[tmp;polyval(cs,tpad)];
    tmp2=filtf(tmp,[t;tpad],[filt(1) filt(2)],[filt(3) filt(4)],phase);
%     tmp3=bandpass(seis(:,k),[filt(1) filt(3)],1/dt,'ImpulseResponse','iir','Steepness',0.5);
    seismogram(:,k)=tmp2(1:length(t));
end
   
end

