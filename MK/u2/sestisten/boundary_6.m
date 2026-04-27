function [XB, YB, polyX, polyY] = boundary_6(R, uk, vk, ub, vb)

% Create the face boundary polygon and project it with the gnomonic projection.
% Close the polygon by repeating the first vertex.
ubc = [ub, ub(1)];
vbc = [vb, vb(1)];

% Transformace do sikme polohy
[sb, db] = uvTosd_6(ubc, vbc, uk, vk);

% Projekce vrcholu
[XB, YB] = gnom_6(R, sb, db);

% Remove the duplicate last point so the polygon is not repeated.
polyX = XB(1:end-1);
polyY = YB(1:end-1);

end
