function plot_sinusoidal_spins_2D(X, Y, M)
    figure('Name', 'Magnetization per position after SPAMM sequence')

    % x Magnetization
    subplot(1, 3, 1)
    imagesc(X(1, :), Y(:, 1), M(:, :, 1)', [-1, 1])
    xlabel('x [m]')
    ylabel('y [m]')
    title('M_x')

    % y magnetization
    subplot(1, 3, 2)
    imagesc(X(1, :), Y(:, 1), M(:, :, 2)', [-1, 1])
    xlabel('x [m]')
    ylabel('y [m]')
    title('M_y')

    % z magnetization
    subplot(1, 3, 3)
    imagesc(X(1, :), Y(:, 1), M(:, :, 3)', [-1, 1])
    xlabel('x [m]')
    ylabel('y [m]')
    title('M_z')
    colormap gray
    colorbar    

end