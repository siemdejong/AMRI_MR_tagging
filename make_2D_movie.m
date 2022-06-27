function make_2D_movie(M, X, Y, time, dt)
    % Output a movie of z-magnetization of a 2D array
    % of spins undergoing T1/T2 relaxation.
    
    Mz1 = squeeze(M(3, 1, :, :));
    surf(X, Y, Mz1);
    axis tight manual;
    caxis manual;
    set(gca,'nextplot','replacechildren');

    v = VideoWriter('2D-time.avi');
    open(v);
    for t = 2:5:length(time)
        title('t =' + string(dt * t) + 's');
        Mz = squeeze(M(3, t, :, :));
        
        surf(X, Y, Mz, ...
            'EdgeColor', 'none', ...
            'FaceColor', 'interp');       

        caxis([-1 1]);
        view(2);
        ylabel('y [m]');
        xlabel('x [m]');
        colormap gray;
        shading interp;
        colorbar;
        frame = getframe(gcf);
        writeVideo(v, frame);
    end

    close(v);

end