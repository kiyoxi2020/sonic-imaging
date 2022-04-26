function sg = preprocess_seis(s,t,x,xshot,xmute,tmute)
% s: ԭʼ�������ݣ�t: ʱ�������
% xshot: ����������λ��
% xmute: �˲���ƫ�ƾ෶Χ��tmute���˲�ƫ�ƾ෶Χ��Ӧ��ʱ�䷶Χ
nshots=length(s);
sg=cell(size(s));                      
g=t;                       
dt=t(2)-t(1);
for kshot=1:nshots
    ss=s{kshot};
    xx=x{kshot};
    ssg=zeros(size(ss));
    % ���������������������֮��ľ��루��ƫ�ƾࣩ
    xoff=abs(xx-xshot(kshot));
    % ���㲻ͬƫ�ƾ���˲�ʱ���
    tmutex=interp1(xmute,tmute,xoff,'spline' );
    for k=1:length(xoff)
        % �����ź�ǿ��ƽ�⴦��
        tmp=ss(:,k).*g;
        % �����˲�
        if(length(xmute)>1)
            imute=min([round(tmutex(k)/dt)+1,length(t)]);
            tmp(1:imute)=0;
        end
        ssg(:,k)=tmp;
    end
    sg{kshot}=ssg;
end
end

