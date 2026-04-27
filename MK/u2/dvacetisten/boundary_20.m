function [XB, YB, polyX, polyY] = boundary_20(R, uk, vk, ub, vb)
% Computes the boundary polygon of an icosahedron face in gnomonic projection
ubc = [ub, ub(1)];
vbc = [vb, vb(1)];

[sb, db] = uvTosd_20(ubc, vbc, uk, vk);
[XB, YB] = gnom_20(R, sb, db);

polyX = XB(1:end-1);
polyY = YB(1:end-1);

end