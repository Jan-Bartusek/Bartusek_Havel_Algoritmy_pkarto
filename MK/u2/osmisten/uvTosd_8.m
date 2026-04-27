function [s, d] = uvTosd_8(u, v, uk, vk)
% uvTosd_8 transforms geographic coordinates [u, v] to the face coordinate system [s, d].

dv = vk - v;

% Compute the face latitude (s).
arg = sin(u).*sin(uk) + cos(u).*cos(uk).*cos(dv);
arg = max(min(arg, 1), -1);
s = asin(arg);

% Compute the face longitude (d) with correct quadrant handling.
num = sin(dv).*cos(u);
den = cos(u).*sin(uk).*cos(dv) - sin(u).*cos(uk);

d = -atan2(num, den);

end