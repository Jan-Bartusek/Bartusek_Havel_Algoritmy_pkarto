function [s, d] = uvTosd_8(u, v, uk, vk)
% Convert geographic coordinates (u,v) to angular distance s and azimuth d


dv = vk - v;

% Cosine of central angle (clamp for numerical safety)
arg = sin(u).*sin(uk) + cos(u).*cos(uk).*cos(dv);
arg = max(min(arg, 1), -1);
s = asin(arg);

% Azimuth components
num = sin(dv).*cos(u);
den = cos(u).*sin(uk).*cos(dv) - sin(u).*cos(uk);

d = -atan2(num, den);
end
