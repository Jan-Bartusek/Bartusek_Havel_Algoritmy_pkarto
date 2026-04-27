function [s, d] = uvTosd_4(u, v, uk, vk)
% Converts geographic coordinates [u,v] to cartographic coordinates relative to pole [uk,vk]

dv = vk - v;

% kartograficka sirka
arg = sin(u).*sin(uk) + cos(u).*cos(uk).*cos(dv);
arg = max(min(arg, 1), -1);
s = asin(arg);

% kartograficka delka - kvadrantove korektne
num = sin(dv).*cos(u);
den = cos(u).*sin(uk).*cos(dv) - sin(u).*cos(uk);

d = -atan2(num, den);

end