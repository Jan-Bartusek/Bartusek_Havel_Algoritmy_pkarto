function [XB, YB, polyX, polyY] = boundary_8(R, uk, vk, ub, vb)
% Boundary and polygon for 8-fold gnomonic face

xClip = x;
yClip = y;

inside = false(size(x));

valid = ~isnan(x) & ~isnan(y);
if any(valid)
    inside(valid) = inpolygon(x(valid), y(valid), polyX, polyY);
end

xClip(~inside) = NaN;
yClip(~inside) = NaN;

end