function plot_sinusoidal_spins_1D_time(spin_magnetizations, time, spin_positions, invert)
    % Makes three subplots: x-, y-, and z-magnitization over time.
    % 
    % spin_magnetizations - the magnetizations over time. [
    % time - timepoints [s]
    % spin_positions - the positions of the spins [m]
    % invert - if the last RF pulse is inverted, invert=true [boolean]

    if invert
        fig_name = 'Magnetization over time, 1D, complementary';
    else
        fig_name = 'Magnetization over time, 1D';
    end
    figure('Name', fig_name)

    subplot(1, 3, 1)
    imagesc(time, spin_positions, squeeze(spin_magnetizations(1, :, :))', [-1, 1])
    colormap gray
    xlabel('time [s]')
    ylabel('x [m]')
    title('M_x')
    colorbar

    subplot(1, 3, 2)
    imagesc(time, spin_positions, squeeze(spin_magnetizations(2, :, :))', [-1, 1])
    colormap gray
    xlabel('time [s]')
    ylabel('x [m]')
    title('M_y')
    colorbar

    subplot(1, 3, 3)
    imagesc(time, spin_positions, squeeze(spin_magnetizations(3, :, :))', [-1, 1])
    title('M_z')
    colormap gray
    xlabel('time [s]')
    ylabel('x [m]')
    colorbar

end