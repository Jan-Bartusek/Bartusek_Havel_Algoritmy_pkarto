function [x, y] = gnom_8(R, s, d)
% gnom_8 performs the gnomonic projection of face coordinates.

rho = R * tan(pi/2 - s);
x = rho .* cos(d);
y = rho .* sin(d);

end