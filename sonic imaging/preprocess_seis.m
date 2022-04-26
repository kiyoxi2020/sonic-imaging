function sg = preprocess_seis(s,t,x,xshot,xmute,tmute)
% s: 原始声场数据，t: 时间采样率
% xshot: 声波发生器位置
% xmute: 滤波的偏移距范围，tmute：滤波偏移距范围对应的时间范围
nshots=length(s);
sg=cell(size(s));                      
g=t;                       
dt=t(2)-t(1);
for kshot=1:nshots
    ss=s{kshot};
    xx=x{kshot};
    ssg=zeros(size(ss));
    % 计算声波发生器与接收器之间的距离（即偏移距）
    xoff=abs(xx-xshot(kshot));
    % 计算不同偏移距的滤波时间点
    tmutex=interp1(xmute,tmute,xoff,'spline' );
    for k=1:length(xoff)
        % 进行信号强度平衡处理
        tmp=ss(:,k).*g;
        % 进行滤波
        if(length(xmute)>1)
            imute=min([round(tmutex(k)/dt)+1,length(t)]);
            tmp(1:imute)=0;
        end
        ssg(:,k)=tmp;
    end
    sg{kshot}=ssg;
end
end

