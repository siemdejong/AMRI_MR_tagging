function plot_contrast(M, M_i, time)
    % Search for min/max after last RF pulse
    [~, min_idx] = min(squeeze(M(3, 401, :)));
    [~, max_idx] = max(squeeze(M(3, 401, :)));

    figure('Name', 'Contrast (C)SPAMM')
    subplot(1, 2, 1)
    title('SPAMM')
    min_M = squeeze(M(3, :, min_idx));
    max_M = squeeze(M(3, :, max_idx));
    plot(time, (max_M - min_M) ./ (max_M + min_M), 'linewidth', 2)
    ylim([0, 20000])
    ylabel('Contrast')
    xlabel('Time [s]')

    subplot(1, 2, 2)
    CSPAMM = M - M_i;
    min_CSPAMM = squeeze(CSPAMM(3, :, min_idx));
    max_CSPAMM = squeeze(CSPAMM(3, :, max_idx));
    title('CSPAMM')
    plot(time, (max_CSPAMM - min_CSPAMM) ./ (max_CSPAMM + min_CSPAMM), 'linewidth', 2)
    ylim([0, 20000])
    ylabel('Contrast')
    xlabel('Time [s]')
end