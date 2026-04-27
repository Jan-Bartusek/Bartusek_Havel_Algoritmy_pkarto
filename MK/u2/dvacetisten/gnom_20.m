function [x, y] = gnom_20(R, s, d)
% Gnomonic projection: converts spherical distance and azimuth to Cartesian coordinates
rho = R * tan(pi/2 - s);
x = rho .* cos(d);
y = rho .* sin(d);

end