function P3 = map2DTo3DTriangle_8(x, y, polyX, polyY, tri3D)
% Map a 2D triangle point to corresponding 3D triangle using barycentric coords

% Extract 2D triangle vertices
x1 = polyX(1); y1 = polyY(1);
x2 = polyX(2); y2 = polyY(2);
x3 = polyX(3); y3 = polyY(3);

% Denominator for barycentric coordinate computation
den = (y2 - y3)*(x1 - x3) + (x3 - x2)*(y1 - y3);

% Barycentric coordinate l1
l1 = ((y2 - y3)*(x - x3) + (x3 - x2)*(y - y3)) / den;
% Barycentric coordinate l2
l2 = ((y3 - y1)*(x - x3) + (x1 - x3)*(y - y3)) / den;
% Barycentric coordinate l3 (closure)
l3 = 1 - l1 - l2;

% Interpolate 3D position from barycentric weights
P3 = l1 * tri3D(1,:) + l2 * tri3D(2,:) + l3 * tri3D(3,:);

end
