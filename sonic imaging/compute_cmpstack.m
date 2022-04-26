function stack=compute_cmpstack(shots,t,xrec,xshots,cmp,velrms,xv)
%%
% shots: �������������ݣ�t: ʱ�������
% xrec: ������λ�ã�xshots: ������λ��
% cmp: [���ĵ�֮��ľ���, ��һ�����ĵ�λ��, ���һ�����ĵ�λ��]
% velrms: ��ʼ�ٶ�ģ�ͣ����ڽ�����ʱ������
% xv: ����ģ�͵ĺ�������
%%
nshots=length(xshots);

for k=1:nshots
    % �����������յ�����ͶӰ�������ĵ㡢��ƫ�ƾ����꣬��������ʱ����
    [shot_nmo]=compute_nmor_cmp(shots{k},t,xrec{k},xshots(k),...
        velrms,xv,cmp(1),cmp(2),cmp(3));
    if(k==1)
        % ��ʼ����������
        stack=zeros(size(shot_nmo));
        foldstack=stack; 
    end
    % �Թ����ĵ����ݽ��е���
    stack=stack+shot_nmo;
    %��¼ÿ����ĵ��Ӵ���
    shot_fold=ones(size(shot_nmo));
    ind=shot_nmo==0;
    shot_fold(ind)=0;
    foldstack=foldstack+shot_fold;
    disp(['Processed shot ' int2str(k) ' of ' int2str(nshots)])
end
% ���ݵ��Ӵ������й�һ��
ind=find(foldstack~=0);
stack(ind)=stack(ind)./foldstack(ind);
end

