function [XB, YB, polyX, polyY] = boundary_8(R, uk, vk, ub, vb)
% Boundary coordinates & polygon for 8-fold gnomonic map

% Close boundary loop
ubc = [ub, ub(1)];
vbc = [vb, vb(1)];

% Convert (u,v) to (s,d)
[sb, db] = uvTosd_8(ubc, vbc, uk, vk);

% Gnomonic map to (X,Y)
[XB, YB] = gnom_8(R, sb, db);

% Polygon X (drop duplicate)
polyX = XB(1:end-1);

% Polygon Y (drop duplicate)
polyY = YB(1:end-1);

end