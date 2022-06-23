function R = effrot(dalpha, phi, dt, df)
% Calculates effective rotation matrix.
    
    domega = 2 * pi * df; % angular frequency [rad/s].
    theta = atan(domega * dt / dalpha); % tilt angle.
    dalphap = dt * sqrt(domega^2 + (dalpha / dt)^2); % effective flip angle.

    % Final effective rotation matrix.
    R = zrot(phi) * yrot(theta) * xrot(dalphap) * yrot(-theta) * zrot(-phi);
end