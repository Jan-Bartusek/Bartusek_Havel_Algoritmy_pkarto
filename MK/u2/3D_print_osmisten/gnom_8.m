function [x, y] = gnom_8(R, s, d)
% GNOM_8 Gnomonic projection: convert angular coordinates (s,d) to plane (x,y).
rho = R * tan(pi/2 - s);   % radial distance on the gnomonic plane
x = rho .* cos(d);         % x-coordinate (east-west)
y = rho .* sin(d);         % y-coordinate (north-south)

end