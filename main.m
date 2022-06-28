% Simulating MR tagging (C)SPAMM
% by Abel Bregman and Siem de Jong
% UvA/VU
%
% Sequence is always
% - RF: pi/2 0
% - Genc
% - RF: pi/2 pi/2

%% 1D time-independent
Nspins = 1000;
Gamp = 40e-3;
tgrad = 10e-3;
invert = true;
[X, M] = sinusoidal_spins_1D(Nspins, Gamp, tgrad, invert);
plot_sinusoidal_spins_1D(X, M)

%% 1D time evolution, neglecting T1/T2 relaxation, including CSPAMM
Nspins = 1000;
Gamp = 100e-3;
tgrad = 10e-3;
T = 1;
dt = 50e-6;
free_precession = true;

% SPAMM
invert = false;
[M, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert);
plot_sinusoidal_spins_1D_time(M, t, X, invert);

% SPAMM with -90 degrees RF pulse
invert = true;
[M_i, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert);
plot_sinusoidal_spins_1D_time(M_i, t, X, invert);

% Plot tagged and anatomical image.
plot_cspamm_images(M, M_i, t, X);

% pause
% 
% % Movies
% Magn2Movie_update(M, 60, dt, 1, 1)
% Magn2Movie_update(M_i, 60, dt, 1, 1)

%% 1D time evolution, moving spins
% Nspins = 10;
% Gamp = 20e-3;
% tgrad = 10e-3;
% T = 10e-1;
% dt = 50e-6;
% free_precession = false;
% invert = false;
% movement = true;
% 
% [X, V, M, t, dt] = sinusoidal_spins_1D_time_movement(Nspins, Gamp, tgrad, T, dt, free_precession, invert, movement);
% % M = M(:, :, 2:end);
% % [A, cmap] = gray2ind(M, 256);
% % movie = immovie(A(:, 3, :), cmap);
% % implay(movie);


%% 1D time evolution, including T1/T2 relaxation and CSPAMM
% Does not give the desired results yet! Tagging image should not have T1
% artifacts, even for smaller T1 (to be set in sinusoidal_spins_1D_time).
Nspins = 100;
Gamp = 20e-3;
tgrad = 10e-3;
T = 1e-1;
dt = 50e-6;
free_precession = true;

% SPAMM
invert = false;
[M, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert);
plot_sinusoidal_spins_1D_time(M, t, X, invert);

% figure('Name', 'CSPAMM')
% subplot(1, 2, 1)
% imagesc(t, X, squeeze(abs(M(1, :, :) + 1i*M(2, :, :)))', [-1, 1])
% title('M_abs, Tagged')
% colormap gray
% xlabel('time [s]')
% ylabel('x [m]')

% SPAMM with -90 degrees RF pulse
invert = true;
[M_i, X, t, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert);
plot_sinusoidal_spins_1D_time(M_i, t, X, invert);

% Plot (C)SPAMM contrast
plot_contrast(M, M_i, t)

% Plot tagged and anatomical image.
plot_cspamm_images(M, M_i, t, X);

pause

% Movies
Magn2Movie_update(M, 60, dt, 1, 1)
% Magn2Movie_update(M_i, 60, dt, 1, 1)

%% 2D time-independent
Nspins = 1e6;
Gamp = 100e-3;
tgrad = 10e-3;

invert = false;
[X, Y, M] = sinusoidal_spins_2D(Nspins, Gamp, tgrad, invert);
plot_sinusoidal_spins_2D(X, Y, M)

invert = true;
[X, Y, M_i] = sinusoidal_spins_2D(Nspins, Gamp, tgrad, invert);
plot_sinusoidal_spins_2D(X, Y, M_i)

% Warp image to mimick movement
M_warped = barrel_warp(M);
plot_sinusoidal_spins_2D(X, Y, M_warped)

% [X, Y, M] = sinusoidal_spins_2D_composite_pulses(Nspins, Gamp, tgrad);


%% 2D time evolution, including T1/T2 relaxation
Nspins = 1000;
Gamp = 80e-3;
tgrad = 10e-3;
T = 1e-1;
dt = 50e-6;
free_precession = true;

% SPAMM
invert = false;
[M, X, Y, time] = sinusoidal_spins_2D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert);

make_2D_movie(M, X, Y, time, dt)

% Show movie of Mz for debugging purposes.
% X = permute(M, [3 4 1 2]);
% [X, cmap] = gray2ind(X, 256);
% movie = immovie(X(:, :, 3, :), cmap);
% implay(movie);
% 
% % SPAMM with -90 degrees RF pulse
% invert = true;
% M = sinusoidal_spins_2D_time(Nspins, Gamp, tgrad, T, dt, free_precession, invert);
% 
% % Show movie of Mz for debugging purposes.
% X = permute(M, [3 4 1 2]);
% [X, cmap] = gray2ind(X, 256);
% movie = immovie(X(:, :, 3, :), cmap);
% implay(movie);

%% 2D time evolution, including T1/T2 relaxation, and movement
% Movement is tried to mimick with a line moving in the y-direction.
% A binary mask containing a line selects spins to move with some velocity.
% Mask itself has to move too, as the spins will be moved.
% Does not yield desired results. It is unclear where the tagged spins go
% to.
%
% For clarity: an X, Y meshgrid is made to keep track of individual spin
% positions. Every spin has a vector V that contains the velocities in the
% x- and y-direction. Magnetizations are still stored in a four
% dimensional matrix with direction/time/spin_x_idx/spin_y_idx. Obviously
% the magnetization matrix does not correspond one-to-one to the velocity
% and position grids. The next section aims to fix this.
%
% KNOWN ISSUES:
% - not using effrot.
Nspins = 1000;
Gamp = 20e-3;
tgrad = 10e-3;
T = 0.5;
dt = 50e-6;
free_precession = true;
movement = true;

% SPAMM
M = sinusoidal_spins_2D_time_movement(Nspins, Gamp, tgrad, T, dt, free_precession, movement);

% Show movie of Mz for debugging purposes.
M = M(:, 2:end, :, :);
X = permute(M, [3 4 1 2]);
[X, cmap] = gray2ind(X, 256);
movie = immovie(X(:, :, 3, :), cmap);
implay(movie);

%% 2D time evolution, including T1/T2 relaxation, and movement (2)
% Basically same as above. However, now the way to save magnetizations is
% changed which might make it easier to access
% magnetizations/velocities/positions of individual spins.
% This way of storing magnetizations does not work, yet.
%
% Individual spins are given a constant velocity V. Every timestep dt, their new
% locations are calculated and stored in X, Y.
Nspins = 1000;
Gamp = 20e-3;
tgrad = 10e-3;
T = 1e-1;
dt = 50e-6;
free_precession = true;
movement = true;

% SPAMM
M = sinusoidal_spins_2D_time_movement2(Nspins, Gamp, tgrad, T, dt, free_precession, movement);

% Show movie of Mz for debugging purposes.
M = M(:, :, :, 2:end);
[X, cmap] = gray2ind(M, 256);
movie = immovie(X(:, :, 3, :), cmap);
implay(movie);
