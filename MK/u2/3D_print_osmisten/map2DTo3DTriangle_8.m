function P3 = map2DTo3DTriangle_8(x, y, polyX, polyY, tri3D)
% Map a 2D point in a triangle to the corresponding 3D point using barycentric coordinates

x1 = polyX(1); y1 = polyY(1);
x2 = polyX(2); y2 = polyY(2);
x3 = polyX(3); y3 = polyY(3);

% Denominator for barycentric coordinates
den = (y2 - y3)*(x1 - x3) + (x3 - x2)*(y1 - y3);

% Barycentric weights
l1 = ((y2 - y3)*(x - x3) + (x3 - x2)*(y - y3)) / den;
l2 = ((y3 - y1)*(x - x3) + (x1 - x3)*(y - y3)) / den;
l3 = 1 - l1 - l2;

% Interpolate 3D position
P3 = l1 * tri3D(1,:) + l2 * tri3D(2,:) + l3 * tri3D(3,:);

end
