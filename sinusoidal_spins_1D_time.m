function [spin_magnetizations, spin_positions, time, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert, flip_angle)
    % This functions outputs a plot of a 1D array of spins that are tagged
    % with the SPAMM tagging sequence.
    % 
    % Nspins - Number of spins
    % Gamp - Gradient amplitude [T / m]
    % tgrad - Gradient duration [s]
    % T - simulation duration [s]
    % dt - simulation timestep duration [s]
    % free_precession - turn on/off T1/T2 relaxation [boolean]
    % movement - turn on/off movement of a horizontal line [boolean]
    % invert - invert the last RF pulse to get complementary magnetization
    % flip_angle - flip angle [rad]

    gamma = 42.58e6; % /s /T

    % Myocardium relaxation times.
    T1 = 995.8e-3;
    T2 = 54e-3;
    time = dt:dt:T;

    spin_positions = linspace(0, 1e-4, Nspins); % 1D [m].
    spin_magnetizations = zeros(3, length(time) + 1, Nspins); % [N m / T]

    for spin = progress(1:Nspins)

        % Initialize magnetization.
        M = [0 0 1]';
        spin_magnetization_evolution = zeros(3, length(time) + 1);
        spin_magnetization_evolution(:, 1) = M;

        for t = 1:length(time)

            % 90 degree RF pulse
            % -> y-axis.
            if t == 100
                M = throt(flip_angle, 0) * M; % 90 degree RF pulse
            end

            % Encoding gradient
            % -> fan out in xy-plane.
            x = spin_positions(spin);
            df = Gamp * x * gamma;
            if t > 200 && t < 200 + tgrad / dt
                phi = 2 * pi * df * dt;
                M = zrot(phi) * M; % Encoding gradient
            end

            % 90 degree RF pulse
            % -> Rotate to zx-plane.
            if t == 400
                if ~invert
                    M = throt(flip_angle, pi) * M; % 90 degree RF pulse
                else
                    M = throt(-flip_angle, pi) * M; % -90 degree RF pulse
                end
            end

            % Allow for relaxation at every timestep.
            if free_precession
                [FP.Afp_dt, FP.Bfp_dt] = freeprecess(dt, T1, T2, df);
                M = FP.Afp_dt * M + FP.Bfp_dt;
            end

            % Save tagged magnetization throughout time.
            spin_magnetization_evolution(:, t) = M;
        end

        spin_magnetizations(:, :, spin) = spin_magnetization_evolution;
    end

    spin_magnetizations = spin_magnetizations(:, 2:end, :, :);

end