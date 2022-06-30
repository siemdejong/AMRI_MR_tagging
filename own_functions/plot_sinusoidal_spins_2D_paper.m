function plot_sinusoidal_spins_2D(X, Y, M)
    figure('Name', 'Mz per position after SPAMM sequence')

    % z magnetization
    imagesc(X(1, :), Y(:, 1), abs(M(:, :, 3))', [0, 1])
    xlabel('x [m]', 'FontSize', 24)
    ylabel('y [m]', 'FontSize', 24)
    colormap gray
    c = colorbar;
    c.Label.String = '|M_z|';
    c.Label.FontSize = 20;

end