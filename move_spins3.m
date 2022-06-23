function [X_new, Y_new] = move_spins3(X, Y, V, dt)
    % Move spins in a selection of positions in the x- and y-direction with
    % velocity vx and vy for a duration dt.
    % X, Y - current locations of spins
    % V - current velocity vectors of spins in grid (x, y [vx, vy])
    % dt - duration of displacement
    % 
    % Returns meshgrid of spin positions after the movement.

    X_new = X + V(:, :, 1) .* dt;
    Y_new = Y + V(:, :, 2) .* dt;

%     imagesc(X - X_new)
%     pause

end