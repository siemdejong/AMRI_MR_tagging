function M = sinusoidal_spins_2D_time_movement2(Nspins, Gamp, tgrad, T, dt, free_precession, movement)
    % This functions outputs a plot of a 2D array of spins that are tagged
    % with the SPAMM tagging sequence.
    % Nspins - number of spins to distribute on the grid.
    % Gamp - gradient amplitude [T / m]
    % tgrad - gradient duration [s]
    % T - simulation duration [s]
    % dt - simulation timesteps [s]
    % free_precession - turn on/off T1/T2 relaxation [boolean]
    % movement - turn on/off movement of a horizontal line [boolean]

    % Myocardium relaxation times.
    T1 = 995.8e-3;
    T2 = 54e-3;
    time = dt:dt:T;
    
    gamma = 42.58e6; % /s /T

    % Initialize position, velocity and magnetization of spin grid.
    xymax = 1e-4;
    [X, Y] = meshgrid(linspace(0, xymax, sqrt(Nspins))); % [m]
    V = zeros([size(X), 2]);
    M = zeros([size(X), 3, length(time) + 1]);
    M(:, :, 3, 1) = 1;

    % Set middle horizontal row of spins with a velocity.
    idx_middle_row = ceil(0.5 * length(V));
    V(idx_middle_row, :, 2) = 1e-6 * xymax; % [m / s]

    for t = progress(2:length(time))
        for spin_x = 1:size(X, 1)
            for spin_y = 1:size(Y, 2)
            
                % 90 degree RF pulse
                % -> y-axis.
                if t == 100
                    M(spin_x, spin_y, :, t) = throt(pi / 2, 0) * squeeze(M(spin_x, spin_y, :, t - 1)); % 90 degree RF pulse
                end
                
                % Encoding gradient
                % -> fan out in xy-plane.
                x = X(1, spin_x);
                df = Gamp * x * gamma;
                if t > 200 && t < 300
                    phi = 2 * pi * df * tgrad;
                    M(spin_x, spin_y, :, t) = zrot(phi) * squeeze(M(spin_x, spin_y, :, t - 1));
                end
            
                % 90 degree RF pulse
                % -> Rotate to zx-plane.
                if t == 400
                    M(spin_x, spin_y, :, t) = throt(pi / 2, pi / 2) * squeeze(M(spin_x, spin_y, :, t - 1)); % 90 degree RF pulse
                end
                
                % Encoding gradient
                % -> make sphere.
                y = Y(spin_y, 1);
                df = Gamp * y * gamma;
                if t == 500
                    phi = 2 * pi * df * tgrad;
                    M(spin_x, spin_y, :, t) = zrot(phi) * squeeze(M(spin_x, spin_y, :, t - 1));
                end
                
                % 90 degree RF pulse
                % -> Rotate to zx-plane.
                if t == 600
                    M(spin_x, spin_y, :, t) = throt(pi / 2, pi / 2) * squeeze(M(spin_x, spin_y, :, t - 1)); % 90 degree RF pulse
                end
            
                % Allow for relaxation at every timestep.
                if free_precession
                    [FP.Afp_dt, FP.Bfp_dt] = freeprecess(dt, T1, T2, df);
                    M(spin_x, spin_y, :, t) = FP.Afp_dt * squeeze(M(spin_x, spin_y, :, t - 1)) + FP.Bfp_dt;
                end
        
                if t > 600
                    if movement
                        [X, Y] = move_spins3(X, Y, V, dt);
                    end
                end
            end
        end
    end

    % Show movie of Mz for debugging purposes.
    M = M(:, :, :, 2:end);
    [X, cmap] = gray2ind(M, 256);
    movie = immovie(X(:, :, 3, :), cmap);
    implay(movie);

end