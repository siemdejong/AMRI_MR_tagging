function [X_new, Y_new] = move_spins(X, Y, selection, vx, vy, dt)
    % Move spins in a selection of positions in the x- and y-direction with
    % velocity vx and vy for a duration dt.
    % X, Y - current locations of spins
    % selection - binary mask selecting the spins to move
    % vx, vy - velocity in x- and y-direction
    % dt - duration of displacement
    % 
    % Returns meshgrid of spin positions after the movement.

    X_temp = selection .* X;
    Y_temp = selection .* Y;

%     X_temp = X_temp + vx * dt;
%     Y_temp = Y_temp + vy * dt;

    X_temp = X_temp + vx * dt;
    Y_temp = Y_temp + vy * dt;

    X_new = X_temp + X;
    Y_new = Y_temp + Y;

%     imagesc(X - X_new)
%     pause

end