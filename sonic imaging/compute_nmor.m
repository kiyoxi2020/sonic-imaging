function sout = compute_nmor(s,t,x,v)

sout=zeros(size(s));

% 根据偏移距，计算延时
tx=sqrt( (x./v).^2 + t.^2 );

% 应用sinc函数插值，进行延时矫正
ind=between(t(1),t(end),tx,2);
sout(ind)=sinci(s,t,tx(ind))';

end

