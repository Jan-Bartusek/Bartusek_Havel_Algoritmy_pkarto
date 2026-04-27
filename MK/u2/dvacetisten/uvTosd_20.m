function [s, d] = uvTosd_20(u, v, uk, vk)
% Converts geographic coordinates [u, v] to general position relative to cartographic pole [uk, vk]

dv = vk - v;

arg = sin(u).*sin(uk) + cos(u).*cos(uk).*cos(dv);
arg = max(min(arg, 1), -1);
s = asin(arg);

num = sin(dv).*cos(u);
den = cos(u).*sin(uk).*cos(dv) - sin(u).*cos(uk);

d = -atan2(num, den);

end