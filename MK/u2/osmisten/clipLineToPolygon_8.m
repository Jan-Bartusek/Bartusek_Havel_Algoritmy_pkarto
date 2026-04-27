function [xClip, yClip] = clipLineToPolygon_8(x, y, polyX, polyY)
% clipLineToPolygon_8 keeps only points inside a polygon and masks the rest.

xClip = x;
yClip = y;

% Determine which points are valid and inside the polygon.
inside = false(size(x));

valid = ~isnan(x) & ~isnan(y);
if any(valid)
    inside(valid) = inpolygon(x(valid), y(valid), polyX, polyY);
end

% Replace points outside the polygon with NaN to break line segments.
xClip(~inside) = NaN;
yClip(~inside) = NaN;

end