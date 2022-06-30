function Rth=throt(alpha,phi)

Rth = zrot(phi)*xrot(alpha)*zrot(-phi);
