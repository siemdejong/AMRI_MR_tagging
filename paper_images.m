% Simulating MR tagging (C)SPAMM
% by Abel Bregman and Siem de Jong
% UvA/VU
%
% Making figures for the term paper

%% 1D time-independent SPAMM 90/-90 degrees
Nspins = 1000;
Gamp = 40e-3;
tgrad = 10e-3;

invert = false;
[X, M] = sinusoidal_spins_1D(Nspins, Gamp, tgrad, invert);

invert = true;
[X, M_i] = sinusoidal_spins_1D(Nspins, Gamp, tgrad, invert);

plot_sinusoidal_spins_1D_merged(X, M, M_i, false)

%% SPAMM 90 degrees
flip_angle = pi / 2;
Nspins = 1e3;
Gamp = 40e-3;
tgrad = 10e-3;
T = 1;
dt = 50e-6;
free_precession = true;

% SPAMM 90/90 degrees
invert = false;
[M, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert, flip_angle);
plot_sinusoidal_spins_1D_time_paper(M, t, X, invert);

% SPAMM 90/-90 degrees
invert = true;
[M_i, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert, flip_angle);
plot_sinusoidal_spins_1D_time_paper(M_i, t, X, invert);

% CSPAMM
plot_cspamm_images_paper(M, M_i, t, X);

M = squeeze(M(:, 10000, :));
M = permute(M, [2, 1]);
M_i = squeeze(M_i(:, 10000, :));
M_i = permute(M_i, [2, 1]);
plot_sinusoidal_spins_1D_merged(X, M, M_i)

%% Flip angle experiment
Nspins = 1e3;
Gamp = 40e-3;
tgrad = 10e-3;
T = 1;
dt = 50e-6;
free_precession = true;
invert = false;

% SPAMM flip_angle/flip_angle degrees
for flip_angle = [pi / 2, pi / 3, pi / 4]
    [M, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert, flip_angle);
    plot_sinusoidal_spins_1D_time_paper(M, t, X, invert);
end

%% Tagging gradient experiment
flip_angle = pi / 2;
Nspins = 1e3;
tgrad = 10e-3;
T = 1;
dt = 50e-6;
free_precession = true;
invert = false;

% SPAMM flip_angle/flip_angle degrees
for Gamp = [40e-3, 70e-3, 100e-3]
    [M, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert, flip_angle);
    plot_sinusoidal_spins_1D_time_paper(M, t, X, invert);
end


%% Contrast experiment
flip_angle = pi / 2;
Nspins = 1000;
Gamp = 100e-3;
tgrad = 10e-3;
T = 1;
dt = 50e-6;
free_precession = true;

% SPAMM
invert = false;
[M, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert, flip_angle);

% SPAMM with -90 degrees RF pulse
invert = true;
[M_i, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert, flip_angle);

% Plot (C)SPAMM contrast
plot_contrast(M, M_i, t)

%% 2D
Nspins = 1e6;
Gamp = 100e-3;
tgrad = 10e-3;
invert = false;

% Taglines
gradtwodim = false;
[X, Y, M] = sinusoidal_spins_2D(Nspins, Gamp, tgrad, invert, gradtwodim);
plot_sinusoidal_spins_2D_paper(X, Y, M)

% Tagging grid
gradtwodim = true;
[X, Y, M] = sinusoidal_spins_2D(Nspins, Gamp, tgrad, invert, gradtwodim);
plot_sinusoidal_spins_2D_paper(X, Y, M)

% Warp image to mimick movement
M_warped = barrel_warp(M);
plot_sinusoidal_spins_2D_paper(X, Y, M_warped)