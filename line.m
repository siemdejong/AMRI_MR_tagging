function line_img = line(width, height, row)

    line_img = zeros(width, height);
    line_img(row, :) = 1;

end