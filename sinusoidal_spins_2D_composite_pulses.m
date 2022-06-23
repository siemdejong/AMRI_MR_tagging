function [X, Y, spin_magnetizations] = sinusoidal_spins_2D_composite_pulses(Nspins, Gamp, tgrad)
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
    
            % x-gradient part
            % 1st part 90 degree RF pulse
            % -> y-axis.
            M = throt(11.25 * pi / 180, 0) * M; 
    
            % 1st Encoding gradient
            % -> fan out in xy-plane.
            x = X(1, spin_x);
            df = Gamp * x * gamma;
            phi = 2 * pi * df * tgrad / 3;
            M = zrot(phi) * M;

            % 2nd part 90 degree RF pulse
            % -> y-axis.
            M = throt(33.75 * pi / 180, 0) * M;

            % 2nd Encoding gradient
            % -> fan out in xy-plane.
            x = X(1, spin_x);
            df = Gamp * x * gamma;
            phi = 2 * pi * df * tgrad / 3;
            M = zrot(phi) * M;

            % 3rd part 90 degree RF pulse
            % -> y-axis.
            M = throt(33.75 * pi / 180, 0) * M;

            % 3rd Encoding gradient
            % -> fan out in xy-plane.
            x = X(1, spin_x);
            df = Gamp * x * gamma;
            phi = 2 * pi * df * tgrad / 3;
            M = zrot(phi) * M;

            % 4th part 90 degree RF pulse
            % -> y-axis.
            M = throt(11.25 * pi / 180, 0) * M;

            % y-gradient part
            % 1st part 90 degree RF pulse
            % -> y-axis.
            M = throt(11.25 * pi / 180, pi / 2) * M; 
    
            % 1st Encoding gradient
            % -> fan out in xy-plane.
            y = Y(1, spin_y);
            df = Gamp * y * gamma;
            phi = 2 * pi * df * tgrad / 3;
            M = zrot(phi) * M;

            % 2nd part 90 degree RF pulse
            % -> y-axis.
            M = throt(33.75 * pi / 180, pi / 2) * M;

            % 2nd Encoding gradient
            % -> fan out in xy-plane.
            y = Y(1, spin_y);
            df = Gamp * y * gamma;
            phi = 2 * pi * df * tgrad / 3;
            M = zrot(phi) * M;

            % 3rd part 90 degree RF pulse
            % -> y-axis.
            M = throt(33.75 * pi / 180, pi / 2) * M;

            % 3rd Encoding gradient
            % -> fan out in xy-plane.
            y = Y(1, spin_y);
            df = Gamp * y * gamma;
            phi = 2 * pi * df * tgrad / 3;
            M = zrot(phi) * M;

            % 4th part 90 degree RF pulse
            % -> y-axis.
            M = throt(11.25 * pi / 180, pi / 2) * M;
    
            % Save tagged magnetization.
            spin_magnetizations(spin_x, spin_y, :) = M;
        end
    end

end