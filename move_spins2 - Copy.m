function [X_new, Y_new] = move_spins2(X, Y, Vx, Vy, dt)
    % Move spins in a selection of positions in the x- and y-direction with
    % velocity vx and vy for a duration dt.
    % X, Y - current locations of spins
    % Vx, Vy - current velocities of spins in x- and y-directions.
    % dt - duration of displacement
    % 
    % Returns meshgrid of spin positions after the movement.

    X_new = X + Vx .* dt;
    Y_new = Y + Vy .* dt;

%     imagesc(X - X_new)
%     pause

end