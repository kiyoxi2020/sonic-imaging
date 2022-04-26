function [shot_nmo]=compute_nmor_cmp(shot,t,x,xshot,...
    vrmsmod,xv,dxcmp,x0cmp,x1cmp)
%%
% shot: 一次声波发生、接收的数据，t: 时间采样点
% x: 接收器位置，xshot: 发生器位置
% vrmsmod: 初始速度模型（用于进行延时矫正）
% xv: 地质模型的横向坐标
% dxcmp: 中心点之间的距离, x0cmp: 第一个中心点位置, x1cmp: 最后一个中心点位置
%%
xv=xv(:)';

% 计算中心点坐标
xcmpraw=(x+xshot)/2;
% 计算偏移距
xoff=abs(x-xshot);

icmp=round((xcmpraw-x0cmp)/dxcmp)+1;%cmp bin numbers for each trace
xcmpnom=x0cmp:dxcmp:x1cmp;%nominal cmp bin centers from origin to max of this shot

xcmp=xcmpnom;
i0=1;
shot_nmo=zeros(length(t),length(xcmp));

% 对每列进行分别处理
for k=1:length(x)
    ind=surround(xv,xcmpraw(k));
    % 插值计算该列对应的初始速度
    vrms=(xcmpraw(k)-xv(ind(1)+1))*vrmsmod(:,ind(1))/(xv(ind(1))-xv(ind(1)+1))...
        +(xcmpraw(k)-xv(ind(1)))*vrmsmod(:,ind(1)+1)/(xv(ind(1)+1)-xv(ind(1))); 
    % 根据该列初始速度进行延时矫正
    shot_nmo(:,icmp(k)-i0+1)=compute_nmor(shot(:,k),t,xoff(k),vrms);

end
end

