function plot_sinusoidal_spins_1D(X, M)
    % Plot spins after SPAMM sequence.

    figure('Name', 'Sinusoidal magnetization after SPAMM sequence')
    subplot(1, 1, 1)
    plot(X, M(:, 3), 'green', ...
        X, M(:, 2), 'blue', ...
        X, M(:, 1), 'red')
    xlim([0, 1e-4])
    xlabel('x [m]')
    ylabel('M')
    legend('Mz', 'My', 'Mx')

end