function spin_magnetizations = sinusoidal_spins_2D_time(Nspins, Gamp, tgrad, T, dt, free_precession)
    % This functions outputs a plot of a 2D array of spins that are tagged
    % with the SPAMM tagging sequence.
    % Nspins - number of spins to distribute on the grid.

    % Myocardium relaxation times.
    T1 = 995.8e-3;
    T2 = 54e-3;
    time = dt:dt:T;
    
    gamma = 42.58e6; % /s /T

    [X, Y] = meshgrid(linspace(0, 1e-4, sqrt(Nspins))); % [m]
    spin_magnetizations = zeros([3, T / dt + 1, size(X)]); % [N m / T]
    
    for spin_x = progress(1:length(X))
        for spin_y = 1:length(Y)
            
            % Initialize magnetization.
            M = [0 0 1]';
            spin_magnetization_evolution = zeros(3, T / dt + 1);
            spin_magnetization_evolution(:, 1) = M;

            for t = 1:length(time)
                % 90 degree RF pulse
                % -> y-axis.
                if t == 100
                    M = throt(pi / 2, 0) * M; % 90 degree RF pulse
                end
        
                % Encoding gradient
                % -> fan out in xy-plane.
                x = X(1, spin_x);
                df = Gamp * x * gamma;
                if t > 200 && t < 300
                    phi = 2 * pi * df * tgrad;
                    M = zrot(phi) * M;
                end
    
                % 90 degree RF pulse
                % -> Rotate to zx-plane.
                if t == 400
                    M = throt(pi / 2, pi / 2) * M; % 90 degree RF pulse
                end
        
                % Encoding gradient
                % -> make sphere.
                y = Y(spin_y, 1);
                df = Gamp * y * gamma;
                if t == 500
                    phi = 2 * pi * df * tgrad;
                    M = zrot(phi) * M;
                end
        
                % 90 degree RF pulse
                % -> Rotate in zy-plane.
                if t == 600
                    M = throt(pi / 2, pi / 2) * M; % 90 degree RF pulse
                end
    
                % Allow for relaxation at every timestep.
                if free_precession
                    [FP.Afp_dt, FP.Bfp_dt] = freeprecess(dt, T1, T2, df);
                    M = FP.Afp_dt * M + FP.Bfp_dt;
                end
        
                % Save tagged magnetization.
                spin_magnetization_evolution(:, t) = M;
            end

            spin_magnetizations(:, :, spin_x, spin_y) = spin_magnetization_evolution;
        end
    end

    spin_magnetizations = spin_magnetizations(:, 2:end, :, :);

end