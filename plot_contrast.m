function plot_contrast(M, M_i, time)
    % Search for min/max after last RF pulse
    [~, min_idx] = min(squeeze(M(3, 401, :)));
    [~, max_idx] = max(squeeze(M(3, 401, :)));

    figure('Name', 'Contrast (C)SPAMM');
    min_M = squeeze(M(3, :, min_idx));
    max_M = squeeze(M(3, :, max_idx));
    plot(time, (max_M - min_M) ./ (max_M), '-.', 'linewidth', 2)
    ylabel('Contrast', 'FontSize', 24)
    xlabel('Time [s]', 'FontSize', 24)

    hold on
    CSPAMM = M - M_i;
    min_CSPAMM = squeeze(CSPAMM(3, :, min_idx));
    max_CSPAMM = squeeze(CSPAMM(3, :, max_idx));
    plot(time, (max_CSPAMM - min_CSPAMM) ./ (max_CSPAMM), '--', 'linewidth', 2)

    legend('SPAMM', 'CSPAMM', 'Location', 'south')
    ax = gca;
    ax.FontSize = 16;

    ylim([0, 2.5])
end