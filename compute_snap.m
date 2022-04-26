function [snapshot] = compute_snap(delx,delt,velocity,snap1,snap2)
[nz,nx]=size(snap1);
% 基于有限差分的波场更新
snapshot=velocity.^2.*delt^2.*del2_5(snap2,delx) + 2*snap2 - snap1;    
% 压制边缘效应
 snapshot(nz,:)=zeros(1,nx);
 snapshot(:,1)=zeros(nz,1);
 snapshot(:,nx)=zeros(nz,1);
 [snapshot]=compute_bc_outer(delx,delt,velocity,snap1,snap2,snapshot);
end

