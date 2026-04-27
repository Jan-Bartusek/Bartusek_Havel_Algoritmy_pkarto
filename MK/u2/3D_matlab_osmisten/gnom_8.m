function [x, y] = gnom_8(R, s, d)
% Gnomonic projection for 8-fold mapping: map (s,d) to plane coordinates

rho = R * tan(pi/2 - s);
x = rho .* cos(d);
y = rho .* sin(d);

end