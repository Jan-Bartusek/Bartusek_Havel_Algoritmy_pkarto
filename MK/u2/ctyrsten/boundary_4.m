function [XB, YB, polyX, polyY] = boundary_4(R, uk, vk, ub, vb)
% Computes boundary polygon of tetrahedron face in gnomonic projection

% Close polygon
ubc = [ub, ub(1)];
vbc = [vb, vb(1)];

% Transform to oblique position
[sb, db] = uvTosd_4(ubc, vbc, uk, vk);

% Project vertices
[XB, YB] = gnom_4(R, sb, db);

% Polygon without duplicate last point
polyX = XB(1:end-1);
polyY = YB(1:end-1);

end