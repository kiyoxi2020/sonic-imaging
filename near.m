function ind=near(v,val1,val2)
% NEAR: return indices of those samples in a vector nearest given bounds
%
% ind=near(v,val1,val2)
% ind=near(v,val1)
%
% NOTE: ind=near(val1,val2,v) is also supported.
%
% NEAR searches the vector v and finds the index,I1, for which
% v(i) is closest to val1 and I2 for which v(i) is closest to
% val2. The returned value is the vector ind=I1:I2 (I2>I1) or
% ind=I1:-1:I2 for I2<I1. This differs from BETWEEN in that the range
% of the selected samples are nearest the given bounds. For example
% between(3.1,4.9,1:10) returns 4, while near(1:10,3.1,4.9) returns
% [3 4 5]. Also NEAR can be run with one limit so that near(1:10,3.1)
% returns 3 . The most common use of near is to define a time zone on a
% seismic trace. Suppose s is such a trace (column vector) and t is a
% vector of identical size giving the times of the samples in s. Assume
% that t extends from 0 to 2, then ind=near(t,.314,1.257) will cause ind to
% be a vector of sample indices that point to the time interval
% .314<t<1.267. Thus s(ind) contains the seismic samples in that time window.
%
% v= input vector
% val1= first input search value
% val2= second input serach value
%  ******** default= val1 ********
% ind= output vector of indicies such that 
% abs(v(l(1))-val1)==minimum and abs(v(l(length(I))-val2)==minimum
%
% by G.F. Margrave, May 1991
%
% NOTE: It is illegal for you to use this software for a purpose other
% than non-profit education or research UNLESS you are employed by a CREWES
% Project sponsor. By using this software, you are agreeing to the terms
% detailed in this software's Matlab source file.
 
% BEGIN TERMS OF USE LICENSE
%
% This SOFTWARE is maintained by the CREWES Project at the Department
% of Geology and Geophysics of the University of Calgary, Calgary,
% Alberta, Canada.  The copyright and ownership is jointly held by 
% its author (identified above) and the CREWES Project.  The CREWES 
% project may be contacted via email at:  crewesinfo@crewes.org
% 
% The term 'SOFTWARE' refers to the Matlab source code, translations to
% any other computer language, or object code
%
% Terms of use of this SOFTWARE
%
% 1) Use of this SOFTWARE by any for-profit commercial organization is
%    expressly forbidden unless said organization is a CREWES Project
%    Sponsor.
%
% 2) A CREWES Project sponsor may use this SOFTWARE under the terms of the 
%    CREWES Project Sponsorship agreement.
%
% 3) A student or employee of a non-profit educational institution may 
%    use this SOFTWARE subject to the following terms and conditions:
%    - this SOFTWARE is for teaching or research purposes only.
%    - this SOFTWARE may be distributed to other students or researchers 
%      provided that these license terms are included.
%    - reselling the SOFTWARE, or including it or any portion of it, in any
%      software that will be resold is expressly forbidden.
%    - transfering the SOFTWARE in any form to a commercial firm or any 
%      other for-profit organization is expressly forbidden.
%
% END TERMS OF USE LICENSE
  
% 
 if nargin<3
    val2=val1;
 end
 
 %allow for the syntax near(val1,val2,v);
 if(length(val2)>1 && nargin>2)
    tmp=v;
    tmp2=val1;
    v=val2;
    val1=tmp;
    val2=tmp2;
  end
    
 
  ilive=find(~isnan(v));
  test=abs(v(ilive)-val1);
  L1= test==min(test);
  test=abs(v(ilive)-val2);
  L2= test==min(test);
  L1=ilive(L1);
  L2=ilive(L2);

 	if L1<=L2
  		ind=min(L1):max(L2);
	else
    	ind=max(L1):-1:min(L2);
 	end
 
