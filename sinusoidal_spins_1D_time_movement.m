function [X, V, M, time, dt] = sinusoidal_spins_1D_time_movement(Nspins, Gamp, tgrad, T, dt, free_precession, invert, movement)
    % This functions outputs a plot of a 1D array of spins that are tagged
    % with the SPAMM tagging sequence.
    % 
    % Nspins - Number of spins
    % Gamp - Gradient amplitude [T / m]
    % tgrad - Gradient duration [s]
    % T - simulation duration [s]
    % dt - simulation timestep duration [s]
    % free_precession - turn on/off T1/T2 relaxation [boolean]
    % invert - invert the last RF pulse to get complementary magnetization
    % movement - turn on/off movement of a horizontal line [boolean]

    gamma = 42.58e6; % /s /T

    % Myocardium relaxation times.
%     T1 = 995.8e-3;    
    T1 = 1000;
    T2 = 54e-3;
    time = dt:dt:T;
    
    X = zeros(Nspins, length(time) + 1); % 1D time dependent [m].
    X(:, 1) = linspace(0, 1e-4, Nspins);
    V = zeros(Nspins, length(time) + 1);
    V(5, 1) = 5 * 1e-4; % [m / s].
    M = zeros(Nspins, 3, length(time) + 1); % [N m / T]

    M(:, 3, 1) = 1; % Initialize magnetization.

    for t = progress(2:length(time))
        M(:, :, t) = M(:, :, t - 1);
        X(:, t) = X(:, t - 1);
        V(:, t) = V(:, t - 1);

        for spin = 1:Nspins
            % 90 degree RF pulse
            % -> y-axis.
            if t == 100
                M(spin, :, t) = throt(pi / 2, 0) * squeeze(M(spin, :, t - 1))'; % 90 degree RF pulse
            end

            % Encoding gradient
            % -> fan out in xy-plane.
            x = X(spin, t);
            df = Gamp * x * gamma;
            if t > 200 && t < 300
                phi = 2 * pi * df * tgrad;
                M(spin, :, t) = zrot(phi) * squeeze(M(spin, :, t - 1))';
            end
            
            % 90 degree RF pulse
            % -> Rotate to zx-plane.
            if t == 400
                if ~invert
                    M(spin, :, t) = throt(pi / 2, 0) * squeeze(M(spin, :, t - 1))'; % 90 degree RF pulse
                else
                    M(spin, :, t) = throt(-pi / 2, 0) * squeeze(M(spin, :, t - 1))'; % -90 degree RF pulse
                end
            end

            % Allow for relaxation at every timestep.
            if free_precession
                [FP.Afp_dt, FP.Bfp_dt] = freeprecess(dt, T1, T2, df);
                M(spin, :, t) = FP.Afp_dt * squeeze(M(spin, :, t - 1))' + FP.Bfp_dt;
            end
        end

        if t > 500 && movement
            X = move_spins_1D(X, V, t, dt);
        end
    end

    M = M(:, :, 2:end);
%     disp(size(X))
%     disp(size(time))
%     disp(size(squeeze(M(:, 3, :))))
%     plot(X)
    disp(size(time))
    disp(size(X))
    disp(squeeze(M(:, 1, :))')
    surf(time, X, squeeze(M(:, 1, :))');
%     imagesc(time, X, squeeze(M(:, 1, :)), [-1, 1]);
%     view(2);
%     imagesc(squeeze(M(:, 3, :)), [-1, 1])
    colormap gray
    colorbar
end

  