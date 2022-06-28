function make_2D_movie(M, X, Y, time, dt)
    % Output a movie of z-magnetization of a 2D array
    % of spins undergoing T1/T2 relaxation.
    
    Mz1 = squeeze(M(3, 1, :, :));
    imagesc(X(1, :), Y(:, 1), Mz1);
    colormap gray;
    axis tight manual;
    set(gca,'nextplot','replacechildren');

    v = VideoWriter('2D-time.avi');
    open(v);

    for t = 2:5:length(time)
        title('t = ' + string(round(dt * t, 4)) + ' s');

        Mz = squeeze(M(3, t, :, :));
        
        imagesc(X(1, :), Y(:, 1), Mz, [-1 1]);
        view(2);
        ylabel('y [m]');
        xlabel('x [m]');
        colormap gray;
        colorbar;

        frame = getframe(gcf);
        writeVideo(v, frame);
    end

    close(v);

end