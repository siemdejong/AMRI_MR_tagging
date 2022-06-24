function plot_cspamm_images(M, M_i, time, spin_positions)
    % Plots two images: tagged CSPAMM image, and anatomical CSPAMM image.

%     tagged_image = abs(M(1, :, :) + 1i*M(2, :, :)) - abs(M_i(1, :, :) + 1i*M_i(2, :, :));
%     anatomical_image = abs(M(1, :, :) + 1i*M(2, :, :)) + abs(M_i(1, :, :) + 1i*M_i(2, :, :));

    tagged_image = M(3, :, :) - M_i(3, :, :);
    anatomical_image = M(3, :, :) + M_i(3, :, :);
    
    figure('Name', 'CSPAMM')
    subplot(1, 2, 1)
    imagesc(time, spin_positions, squeeze(tagged_image)', [-1, 1])
    title('M_z, Tagged')
    colormap gray
    xlabel('time [s]')
    ylabel('x [m]')
    
    subplot(1, 2, 2)
    imagesc(time, spin_positions, squeeze(anatomical_image)', [-1, 1])
    title('M_z, Anatomical')
    colormap gray
    xlabel('time [s]')
    ylabel('x [m]')
    colorbar

end