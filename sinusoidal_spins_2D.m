function [X, Y, spin_magnetizations] = sinusoidal_spins_2D(Nspins, Gamp, tgrad)
    % This functions outputs a plot of a 2D array of spins that are tagged
    % with the SPAMM tagging sequence.
    % 
    % Nspins - Number of spins
    % Gamp - Gradient amplitude [T / m]
    % tgrad - Gradient duration [s]
    
    gamma = 42.58e6; % /s /T

    [X, Y] = meshgrid(linspace(0, 1e-4, sqrt(Nspins))); % [m]
    spin_magnetizations = zeros([size(X), 3]); % [N m / T]
    
    for spin_x = 1:length(X)
        for spin_y = 1:length(Y)
            
            % Initialize magnetization.
            M = [0 0 1]'; 
    
            % 90 degree RF pulse
            % -> y-axis.
            M = throt(pi / 2, 0) * M; 
    
            % Encoding gradient
            % -> fan out in xy-plane.
            x = X(1, spin_x);
            df = Gamp * x * gamma;
            phi = 2 * pi * df * tgrad;
            M = zrot(phi) * M;

            % 90 degree RF pulse
            % -> fan moved to zx plane.
            M = throt(pi / 2, 0) * M; 
    
            % Encoding gradient
            % -> make sphere.
            y = Y(spin_y, 1);
            df = Gamp * y * gamma;
            phi = 2 * pi * df * tgrad;
            M = zrot(phi) * M;
    
            % 90 degree RF pulse
            % -> Rotate to ....
            M = throt(pi / 2, pi / 2) * M; 
    
            % Save tagged magnetization.
            spin_magnetizations(spin_x, spin_y, :) = M;
        end
    end

end