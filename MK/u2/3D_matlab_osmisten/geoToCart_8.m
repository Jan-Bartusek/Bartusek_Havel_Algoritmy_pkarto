function xyz = geoToCart_8(u, v)
% Convert (u,v) to (x,y,z) on unit sphere

x = cos(u) .* cos(v);
y = cos(u) .* sin(v);
z = sin(u);

xyz = [x, y, z];
end