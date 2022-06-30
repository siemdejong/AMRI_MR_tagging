function line_mask = line_mask(Y, row)
    % Outputs binary mask to be used with move_spins.
    % Y - matrix giving y-positions of spins
    % row - row to move.

    line_mask = zeros(size(Y));
    line_mask(row, :) = 1;
end