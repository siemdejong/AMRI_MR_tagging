t = 2*pi:.1:8*pi;

% cline(sqrt(t).*sin(t), sqrt(t).*cos(t)); view(3)                       % Example 1
% cline(sqrt(t).*sin(t), sqrt(t).*cos(t), t); view(3)                    % Example 2
% cline(sqrt(t).*sin(t), sqrt(t).*cos(t), t, rand(size(t))); view(3)     % Example 3
cline(sqrt(t).*sin(t), sqrt(t).*cos(t), t, t); view(3)	 % Example 4