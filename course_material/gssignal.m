% 
%	function [Msig,Mss] = gssignal(flip,T1,T2,TE,TR,df,phi)
% 
%	Calculate the steady state signal at TE for repeated
%	excitations given T1,T2,TR,TE in ms.  df is the resonant
%	frequency in Hz.  flip is in radians.
%	phi is the phase twist at the end of the sequence.

function [Msig,Mss] = gssignal(alpha,T1,T2,TE,TR,df,phi)

Rflip = yrot(alpha);
[Atr,Btr] = freeprecess(TR-TE,T1,T2,df);
[Ate,Bte] = freeprecess(TE,T1,T2,df);

% 	To add the gradient spoiler twist, we just
%	multiply Atr by zrot(phi):

Atr = zrot(phi)*Atr;

% Let 	M1 be the magnetization just before the tip.
%	M2 be just after the tip.
%	M3 be at TE.
%
% then
%	M2 = Rflip * M1
%	M3 = Ate * M2 + Bte
%	M1 = Atr * M3 + Btr
%
% Solve for M3...
%
%	M3 = Ate*Rflip*Atr*M3 + (Ate*Rflip*Btr+Bte)

Mss = inv(eye(3)-Ate*Rflip*Atr) * (Ate*Rflip*Btr+Bte);
Msig = Mss(1)+i*Mss(2);

