% 
%	function [Msig,Mss] = gresignal(flip,T1,T2,TE,TR,df)
% 
%	Calculate the steady state gradient-spoiled signal at TE for repeated
%	excitations given T1,T2,TR,TE in ms.  df is the resonant
%	frequency in Hz.  flip is in radians.


function [Msig,Mss] = gresignal(alpha,T1,T2,TE,TR,df)


N = 100;
M = zeros(3,N);
phi = ([1:N]/N-0.5 ) * 4*pi;


for k=1:N
	[M1sig,M1] = gssignal(alpha,T1,T2,TE,TR,df,phi(k));
	M(:,k)=M1;
end;


Mss = mean(M')';
Msig = Mss(1)+i*Mss(2);



