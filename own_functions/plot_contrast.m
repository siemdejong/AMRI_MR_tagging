function plot_contrast(M, M_i, time)
    % Calculates contrast and plots the contrast.
    % M - magnetization vector for N spins in time after SPAMM 90/90.
    % M_i - M, but with a SPAMM 90/-90 degree sequence.
    % time - a list with timepoints [s].

    Mz = abs(squeeze(M(3, :, :)));
    Mz_i = abs(squeeze(M_i(3, :, :)));
    CSPAMMz = Mz - Mz_i;

    min_Mz = zeros(size(time));
    max_Mz = zeros(size(time));
    min_CSPAMMz = zeros(size(time));
    max_CSPAMMz = zeros(size(time));

    disp("Calculating extrema for " + length(time) + " timepoints.")
    for t = progress(1:length(time))
        min_Mz(1, t) = min(Mz(t, :));
        max_Mz(1, t) = max(Mz(t, :));

        % Rescale (minmax normalization), because otherwise unfair
        % comparison.
        CSPAMMz(t, :) = rescale(CSPAMMz(t, :));
        min_CSPAMMz(1, t) = min(CSPAMMz(t, :));
        max_CSPAMMz(1, t) = max(CSPAMMz(t, :));
    end

    figure('Name', 'Contrast (C)SPAMM');
    % Michelson contrast to make sure CSPAMM contrast makes sense.
    plot(time, (max_Mz - min_Mz)' ./ (max_Mz + min_Mz)', '-.', 'linewidth', 2)
    ylabel('Contrast', 'FontSize', 24)
    xlabel('Time [s]', 'FontSize', 24)

    hold on
    plot(time, (max_CSPAMMz - min_CSPAMMz)' ./ (max_CSPAMMz + min_CSPAMMz)', '--', 'linewidth', 2)

    ylim([0, 1.2])

    legend('SPAMM', 'CSPAMM', 'Location', 'south')
    ax = gca;
    ax.FontSize = 16;
end