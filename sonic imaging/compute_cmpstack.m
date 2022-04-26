function stack=compute_cmpstack(shots,t,xrec,xshots,cmp,velrms,xv)
%%
% shots: 声波接收器数据，t: 时间采样点
% xrec: 接收器位置，xshots: 发生器位置
% cmp: [中心点之间的距离, 第一个中心点位置, 最后一个中心点位置]
% velrms: 初始速度模型（用于进行延时矫正）
% xv: 地质模型的横向坐标
%%
nshots=length(xshots);

for k=1:nshots
    % 将发生、接收点坐标投影到共中心点、共偏移距坐标，并进行延时矫正
    [shot_nmo]=compute_nmor_cmp(shots{k},t,xrec{k},xshots(k),...
        velrms,xv,cmp(1),cmp(2),cmp(3));
    if(k==1)
        % 初始化成像数据
        stack=zeros(size(shot_nmo));
        foldstack=stack; 
    end
    % 对共中心点数据进行叠加
    stack=stack+shot_nmo;
    %记录每个点的叠加次数
    shot_fold=ones(size(shot_nmo));
    ind=shot_nmo==0;
    shot_fold(ind)=0;
    foldstack=foldstack+shot_fold;
    disp(['Processed shot ' int2str(k) ' of ' int2str(nshots)])
end
% 根据叠加次数进行归一化
ind=find(foldstack~=0);
stack(ind)=stack(ind)./foldstack(ind);
end

