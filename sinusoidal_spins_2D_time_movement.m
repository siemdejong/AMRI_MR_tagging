function spin_magnetizations = sinusoidal_spins_2D_time_movement(Nspins, Gamp, tgrad, T, dt, free_precession, movement)
    % This functions outputs a plot of a 2D array of spins that are tagged
    % with the SPAMM tagging sequence.
    % Nspins - number of spins to distribute on the grid.

    % Myocardium relaxation times.
    T1 = 995.8e-3;
    T2 = 54e-3;
    time = dt:dt:T;
    
    gamma = 42.58e6; % /s /T

    xymax = 1e-4;
    [X, Y] = meshgrid(linspace(0, xymax, sqrt(Nspins))); % [m]
    spin_magnetizations = zeros([3, T / dt + 1, size(X)]); % [N m / T]

    for spin_x = progress(1:length(X))
        for spin_y = 1:length(Y)

            moving_line_position = 0.5 * xymax; % Initiate horizontal line in middle [m]
            vx = 0; % [m / s]
            vy = 0.1 * xymax; % [m / s]
            
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

                % Only do movements after tagging sequence for clarity.
                if t > 600
                if movement

                    % Move mask with same velocity as spins.
                    selection = line_mask(Y, ceil(moving_line_position / xymax * size(Y, 2)));
%                     if mod(t, 100) == 0
%                     imagesc(selection)
%                     drawnow
%                     end
                    moving_line_position = moving_line_position + vy * dt;
%                     if moving_line_position > 0.51 * length(X) || moving_line_position < 0.49 * length(X)
%                         vy = -vy;
%                     end

                    [X, Y] = move_spins(X, Y, selection, vx, vy, dt);
                end
                end
        
                % Save tagged magnetization.
                spin_magnetization_evolution(:, t) = M;
            end

            spin_magnetizations(:, :, spin_x, spin_y) = spin_magnetization_evolution;
        end
    end

    spin_magnetizations = spin_magnetizations(:, 2:end, :, :);

    X = permute(spin_magnetizations, [3 4 1 2]);
    [X, cmap] = gray2ind(X, 256);
    movie = immovie(X(:, :, 3, :), cmap);
    implay(movie);

end