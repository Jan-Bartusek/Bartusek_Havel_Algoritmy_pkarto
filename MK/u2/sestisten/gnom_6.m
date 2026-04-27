function [x, y] = gnom_6(R, s, d)
% Project spherical coordinates to the gnomonic plane.

rho = R * tan(pi/2 - s);
x = rho .* cos(d);
y = rho .* sin(d);

end
