function [Afp_dt,Bfp_dt]=freeprecess(dt,T1,T2,df)
%
%	Function simulates free precession and decay
%	over a time interval T, given relaxation times T1 and T2
%	and off-resonance df.  Times in s, off-resonance in Hz.

phi = 2*pi*df*dt;	% Resonant precession, radians.
E1 = exp(-dt/T1);	
E2 = exp(-dt/T2);

Afp_dt = [E2 0 0;0 E2 0;0 0 E1]*zrot(phi);
Bfp_dt = [0 0 1-E1]';

end