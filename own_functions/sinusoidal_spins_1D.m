function [spin_positions, spin_magnetizations] = sinusoidal_spins_1D(Nspins, Gamp, tgrad, invert)
    % This functions outputs a plot of a 1D array of spins that are tagged
    % with the SPAMM tagging sequence.
    % 
    % Nspins - Number of spins
    % Gamp - Gradient amplitude [T / m]
    % tgrad - Gradient duration [s]

    gamma = 42.58e6; % /s /T

    spin_positions = linspace(0, 1e-4, Nspins); % 1D [m].
    spin_magnetizations = zeros(Nspins, 3); % [N m / T]

    for spin = 1:Nspins

        % Initialize magnetization.
        M = [0 0 1]'; 

        % 90 degree RF pulse
        % -> y-axis.
        M = throt(pi / 2, 0) * M; 

        % Encoding gradient
        % -> fan out in xy-plane.
        x = spin_positions(spin);
        df = Gamp * x * gamma;
        phi = 2 * pi * df * tgrad;
        M = zrot(phi) * M; 

        % 90 degree RF pulse
        % -> Rotate to zx-plane.
        if ~invert
            M = throt(pi / 2, pi) * M;
        else
            M = throt(-pi / 2, pi) * M;
        end

        % Save tagged magnetization.
        spin_magnetizations(spin, :) = M;
    
    end

end