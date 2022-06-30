function plot_cspamm_images_paper(M, M_i, time, spin_positions)
    % Plots tagged CSPAMM image.

    tagged_image = abs(M(3, :, :)) - abs(M_i(3, :, :));
%     tagged_image = M(3, :, :) - M_i(3, :, :);
    tagged_image = tagged_image;

    figure('Name', 'CSPAMM')
    subplot(1, 1, 1)
    title('CSPAMM')
    imagesc(time, spin_positions, squeeze(tagged_image(1, :, :))', [-1, 1])
    colormap gray;
    c = colorbar;
    c.Label.String = 'M_z';
    c.Label.FontSize = 20;
    xlabel('Time [s]', 'FontSize', 24)
    ylabel('x [m]', 'FontSize', 24)

end