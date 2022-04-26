function [seismogram,seis,t]=shotrec(dx,dtstep,dt,tmax, ...
         model,snap1,xrec,zrec,filt,phase)
%%
% dx: �ռ���������dtstep������������ʱ�������
% dt����������ʱ������ʣ�tmax�����������������ʱ��
% model���ٶ�ģ�ͣ�snap1����ʼ��������
% xrec������������������λ�ã�zrec������������������λ��
% filt���˲���
%%
velocity=model;                                         % �ٶ�ģ��
[nz,~]=size(snap1);
nrec=length(xrec);                                      % ��������
seis=zeros(floor(tmax/dtstep),nrec);                    % ��������������
ixrec=floor(xrec./dx)+1;
izrec=floor(zrec./dx)+1;
irec=(ixrec-1)*nz+izrec;
seis(1,:)=snap1(irec);                                  % ��ȡ����������λ�õĲ�������
maxstep=round(tmax/dtstep)-1;                           % ����������ʱ���������
disp(['There are ' int2str(maxstep) ' steps to complete']);
time0=clock;
nwrite=2*round(maxstep/50)+1;
snap2=snap1;                                            % ʱ��t�Ĳ���
snap1=zeros(size(snap2));                               % ʱ��t-1�Ĳ���s
% h=figure;set(gcf,'position',[100,100,1500,520]);
% writerObj=VideoWriter('wave-propagation.avi');  %// ����һ����Ƶ�ļ������涯��
% writerObj.FrameRate = 60;
% open(writerObj);  
for k=1:1:maxstep
    snap0=snap2;
    snap2=compute_snap(dx,dtstep,velocity,snap1,snap2); % ���޲�ָ���t+1ʱ�̲���
    snap1=snap0;
    pause(0.01);title([num2str(k),'/',num2str(maxstep)])
    seis(k+1,:)=snap2(irec);                            % ��ȡ����������λ�õĲ�������
    
    if rem(k,nwrite) == 0                               % ��ʾ��ǰ�����������
        timenow=clock;
        tottime=etime(timenow,time0);
        timeperstep=tottime/k;
        timeleft=timeperstep*(maxstep-k);
        
        disp(['wavefield propagated to ' num2str(k*dtstep) ...
            ' s; computation time remaining ' ...
            num2str(timeleft) ' s']);
    end
    
    
%     subplot(1,2,1)
%     imagesc(filter2d_butter(snap2,dtstep,200),[-0.05,0.05]);colormap gray;title('������������')
%     subplot(1,2,2)
%     seis0=imresize(seis,[round(dtstep/dt*maxstep),nrec]);
%     imagesc(filter2d_butter(seis0,dt,50),[-0.05,0.05]);colormap gray;title('�����������ź�')
%     pause(0.01);
%  A =  getframe(gcf);            %// ��ͼ�������Ƶ�ļ���
%  writeVideo(writerObj,A); %// ��֡д����Ƶ
 
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

