function [XB, YB, polyX, polyY] = boundary_8(R, uk, vk, ub, vb)
% boundary_8 computes the projected boundary of a face polygon.

% Close the polygon by repeating the first vertex at the end.
ubc = [ub, ub(1)];
vbc = [vb, vb(1)];

% Transform geographic coordinates to the general face orientation.
[sb, db] = uvTosd_8(ubc, vbc, uk, vk);

% Project boundary vertices using the gnomonic projection.
[XB, YB] = gnom_8(R, sb, db);

% Remove the duplicate final point from the polygon.
polyX = XB(1:end-1);
polyY = YB(1:end-1);

end