function sout = compute_nmor(s,t,x,v)

sout=zeros(size(s));

% ����ƫ�ƾ࣬������ʱ
tx=sqrt( (x./v).^2 + t.^2 );

% Ӧ��sinc������ֵ��������ʱ����
ind=between(t(1),t(end),tx,2);
sout(ind)=sinci(s,t,tx(ind))';

end

