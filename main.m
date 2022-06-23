% 1D time evolution
Nspins = 100;
Gamp = 10e-3;
tgrad = 10e-3;
T = 1;
dt = 50e-6;
free_precession = true;

cspamm = false;
[spin_magnetizations_spamm, spin_positions, time, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, cspamm);
plot_sinusoidal_spins_1D_time(spin_magnetizations_spamm)

cspamm = true;
[spin_magnetizations_cspamm, spin_positions, time, dt] = sinusoidal_spins_1D_time(Nspins, Gamp, tgrad, T, dt, free_precession, true);
plot_sinusoidal_spins_1D_time(spin_magnetizations_cspamm)
tagged_image = spin_magnetizations_spamm(3, :, :) - spin_magnetizations_cspamm(3, :, :);
anatomical_image = spin_magnetizations_spamm(3, :, :) + spin_magnetizations_cspamm(3, :, :);

figure('Name', 'CSPAMM')
subplot(1, 2, 1)
imagesc(time, spin_positions, squeeze(tagged_image)', [-1, 1])
title('M_z, Tagged')
colormap gray
xlabel('time [s]')
ylabel('x [m]')

subplot(1, 2, 2)
imagesc(time, spin_positions, squeeze(anatomical_image)', [-1, 1])
title('M_z, Anatomical')
colormap gray
xlabel('time [s]')
ylabel('x [m]')
colorbar

pause
close
movie_sinusoidal_spins_1D_time(spin_magnetizations_spamm, 60, dt, 1, 1);