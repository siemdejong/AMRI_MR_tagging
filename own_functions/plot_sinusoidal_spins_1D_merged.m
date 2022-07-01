function plot_sinusoidal_spins_1D_merged(X, M, M_i, cspamm)

    figure('Name', 'Mz after SPAMM 90/-90 degrees sequence')
    p = subplot(1, 1, 1);
    p.FontSize = 24;

    p1 = plot(X, abs(M(:, 3)));
    p1.Color = 'green';
    p1.LineStyle = '-';
    p1.LineWidth = 3;

    hold on
    p2 = plot(X, abs(M_i(:, 3)));
    p2.Color = 'blue';
    p2.LineStyle = '-.';
    p2.LineWidth = 3;

    if cspamm
        hold on
        p3 = plot(X, abs(M(:, 3)) - abs(M_i(:, 3)));
        p3.Color = '#FFA500';
        p3.LineStyle = '-';
        p3.LineWidth = 1;

        legend('90°/90°', '90°/-90°', 'CSPAMM', 'Location', 'east', 'FontSize', 17)
    else
        legend('90°/90°', '90°/-90°', 'Location', 'east', 'FontSize', 17)
    end
    xlim([0, 1e-4])
    xlabel('x [m]', 'FontSize', 24)
    ylabel('|M_z|', 'FontSize', 24)

end