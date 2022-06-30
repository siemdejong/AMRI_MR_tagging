function I_barrel = barrel_warp(M)
    % Apply barrel warp to mimick displacement of spins.
    % M current magnetization image
    ncols = size(M, 2);
    nrows = size(M, 1);
    [xi, yi] = meshgrid(1:ncols,1:nrows);

    % Shift origin to center
    xt = xi - ncols / 2;
    yt = yi - nrows / 2;

    % Convert to polar coordinates
    [theta,r] = cart2pol(xt, yt);

    a = 1; % Try varying the amplitude of the cubic term.
    rmax = max(r(:));
    s1 = r + r.^3*(a/rmax.^2);

    % Convert back to cartesian coordinates.
    [ut,vt] = pol2cart(theta,s1);

    % Shift origin back.
    ui = ut + ncols/2;
    vi = vt + nrows/2;

    % Store transformation in transform object
    ifcn = @(c) [ui(:) vi(:)];
    tform = geometricTransform2d(ifcn);
    
    % Apply transformation
    I_barrel = imwarp(M,tform);

end