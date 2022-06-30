function [Msig, Mss]=sssignal(alpha,T1,T2,TE,TR,df)

Rflip = yrot(alpha);
[Atr, Btr] = freeprecess(TR, T1, T2, df);
[Ate, Bte] = freeprecess(TE, T1, T2, df);

Mss = inv(eye(3)-Ate*Rflip*Atr) * (Ate*Rflip*Btr+Bte);
Msig = Mss(1)+i*Mss(2);