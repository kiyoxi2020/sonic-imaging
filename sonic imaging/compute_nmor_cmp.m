function [shot_nmo]=compute_nmor_cmp(shot,t,x,xshot,...
    vrmsmod,xv,dxcmp,x0cmp,x1cmp)
%%
% shot: һ���������������յ����ݣ�t: ʱ�������
% x: ������λ�ã�xshot: ������λ��
% vrmsmod: ��ʼ�ٶ�ģ�ͣ����ڽ�����ʱ������
% xv: ����ģ�͵ĺ�������
% dxcmp: ���ĵ�֮��ľ���, x0cmp: ��һ�����ĵ�λ��, x1cmp: ���һ�����ĵ�λ��
%%
xv=xv(:)';

% �������ĵ�����
xcmpraw=(x+xshot)/2;
% ����ƫ�ƾ�
xoff=abs(x-xshot);

icmp=round((xcmpraw-x0cmp)/dxcmp)+1;%cmp bin numbers for each trace
xcmpnom=x0cmp:dxcmp:x1cmp;%nominal cmp bin centers from origin to max of this shot

xcmp=xcmpnom;
i0=1;
shot_nmo=zeros(length(t),length(xcmp));

% ��ÿ�н��зֱ���
for k=1:length(x)
    ind=surround(xv,xcmpraw(k));
    % ��ֵ������ж�Ӧ�ĳ�ʼ�ٶ�
    vrms=(xcmpraw(k)-xv(ind(1)+1))*vrmsmod(:,ind(1))/(xv(ind(1))-xv(ind(1)+1))...
        +(xcmpraw(k)-xv(ind(1)))*vrmsmod(:,ind(1)+1)/(xv(ind(1)+1)-xv(ind(1))); 
    % ���ݸ��г�ʼ�ٶȽ�����ʱ����
    shot_nmo(:,icmp(k)-i0+1)=compute_nmor(shot(:,k),t,xoff(k),vrms);

end
end

