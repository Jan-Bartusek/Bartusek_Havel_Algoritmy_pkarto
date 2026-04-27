function [s, d] = uvTosd_8(u, v, uk, vk)
% Convert geographic coords [u,v] to (s,d) relative to map center [uk,vk]

% Difference in longitude
dv = vk - v;

% Compute cosine of central angle argument
arg = sin(u).*sin(uk) + cos(u).*cos(uk).*cos(dv);
% Clamp numerical errors into valid range for asin
arg = max(min(arg, 1), -1);
% s: angular distance from map center
s = asin(arg);

% Numerator for azimuth computation
num = sin(dv).*cos(u);
% Denominator for azimuth computation
den = cos(u).*sin(uk).*cos(dv) - sin(u).*cos(uk);

% d: azimuth (signed) from map center
d = -atan2(num, den);

end
