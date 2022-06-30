function plot_sinusoidal_spins_1D_time_paper(spin_magnetizations, time, spin_positions, invert)
    % Makes z-magnitization over time.
    % 
    % spin_magnetizations - the magnetizations over time.
    % time - timepoints [s]
    % spin_positions - the positions of the spins [m]
    % invert - if the last RF pulse is inverted, invert=true [boolean]

    image = squeeze(abs(spin_magnetizations(3, :, :)))';

    if invert
        fig_name = 'Magnetization over time, 1D, complementary';
    else
        fig_name = 'Magnetization over time, 1D';
    end
    figure('Name', fig_name)

    subplot(1, 1, 1)
    if invert
        fig_title = 'SPAMM 90/90';
    else
        fig_title = 'SPAMM 90/-90';
    end
    title(fig_title);
    imagesc(time, spin_positions, image, [0, 1])
    colormap gray;
    c = colorbar;
    c.Label.String = 'M_z';
    c.Label.FontSize = 20;
    xlabel('Time [s]', 'FontSize', 24)
    ylabel('x [m]', 'FontSize', 24)
    

end