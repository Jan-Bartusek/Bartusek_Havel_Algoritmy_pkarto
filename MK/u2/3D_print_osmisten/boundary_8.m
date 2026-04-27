function [XB, YB, polyX, polyY] = boundary_8(R, uk, vk, ub, vb)
% Compute boundary and polygon for an 8-fold gnomonic face

% Close boundary loop by appending first vertex
ubc = [ub, ub(1)];
vbc = [vb, vb(1)];

% Convert closed (u,v) boundary to (s,d) relative to face center
[sb, db] = uvTosd_8(ubc, vbc, uk, vk);

% Project (s,d) to gnomonic plane coordinates
[XB, YB] = gnom_8(R, sb, db);

% Polygon vertices: drop duplicated closing point (X)
polyX = XB(1:end-1);

% Polygon vertices: drop duplicated closing point (Y)
polyY = YB(1:end-1);

end
