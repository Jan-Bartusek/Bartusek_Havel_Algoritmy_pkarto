function [x, y] = gnom_4(R, s, d)
% Gnomonic projection: transforms cartographic coordinates to planar coordinates

rho = R * tan(pi/2 - s);
x = rho .* cos(d);
y = rho .* sin(d);

end