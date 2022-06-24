function X_new = move_spins_1D(X, V, t, dt)
    % Move spins in a selection of positions in the x-direction with
    % velocity V for a duration dt.
    % X- current locations of spins
    % V - current velocity spins in array
    % t - current timepoint
    % dt - duration of displacement
    % 
    % Returns meshgrid of spin positions after the movement.

    X_new = X;
    X_new(:, t) = X(:, t) + V(:, t) .* dt;

end