
function [Msig,Mss] = sesignal(T1,T2,TE,TR,df)

Rflip = yrot(pi/2);	% Rotation from excitation pulse (90)
Rrefoc = xrot(pi);	% Rotation from refocusing pulse (usually 180)

[Atr,Btr] = freeprecess(TR-TE,T1,T2,df);	% Propagation TE to TR
[Ate2,Bte2] = freeprecess(TE/2,T1,T2,df);	% Propagation 0 to TE/2
						% (same as TE/2 to TE)

% Neglect residual transverse magnetization prior to excitation.
Atr = [0 0 0;0 0 0;0 0 1]*Atr;		% (Just keep Mz component)

Mss = inv(eye(3)-Ate2*Rrefoc*Ate2*Rflip*Atr) * (Bte2+Ate2*Rrefoc*(Bte2+Ate2*Rflip*Btr));

Msig = Mss(1)+i*Mss(2);
