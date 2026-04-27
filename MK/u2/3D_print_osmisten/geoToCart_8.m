function xyz = geoToCart_8(u, v)
% Convert geographic coordinates (latitude u, longitude v) to 3D

x = cos(u) .* cos(v);
y = cos(u) .* sin(v);
z = sin(u);

xyz = [x, y, z];
end