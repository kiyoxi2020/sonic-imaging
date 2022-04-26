function out = filter2d_butter(snap, dtstep, fc)

fs = 1/dtstep;
[b,a] = butter(2,fc/(fs/2));
L = size(snap,2);
out = zeros(size(snap));
for i = 1:1:L
    s1 = snap(:,i);
    ind = (abs(s1)>1e-6);
        t = s1(ind);
    if ~isempty(t)
        t = filter(b,a,t);
        out(ind,i) = t;
    end
end

end

