function [s, d] = uvTosd_6(u, v, uk, vk)
% Convert geographic coordinates [u, v] to rotated spherical coordinates [s, d]
% relative to the cartographic face center [uk, vk].

 dv = vk - v;

 arg = sin(u).*sin(uk) + cos(u).*cos(uk).*cos(dv);
 arg = max(min(arg, 1), -1);
 s = asin(arg);

 num = sin(dv).*cos(u);
 den = cos(u).*sin(uk).*cos(dv) - sin(u).*cos(uk);

 d = -atan2(num, den);

end
