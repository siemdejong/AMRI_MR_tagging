function plot_sinusoidal_spins_1D(X, M)
    % Plot spins after SPAMM sequence.

    figure('Name', 'Sinusoidal magnetization after SPAMM sequence')
    subplot(1, 1, 1)
    plot(X, M(:, 3), 'green', ...
        X, M(:, 2), 'blue', ...
        X, M(:, 1), 'red')
    xlabel('x [m]')
    ylabel('M [N m T^{-1}]')
    legend('Mz', 'My', 'Mx')

end