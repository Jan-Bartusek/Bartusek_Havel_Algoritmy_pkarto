function [xClip, yClip] = clipLineToPolygon_8(x, y, polyX, polyY)
% Clip a line to a polygon for 8-fold mapping

% Initialize outputs as copies of inputs
xClip = x;
yClip = y;

% Preallocate logical mask for points inside polygon
inside = false(size(x));

% Valid points are those not NaN
valid = ~isnan(x) & ~isnan(y);

% Test only valid points for being inside the polygon
if any(valid)
    inside(valid) = inpolygon(x(valid), y(valid), polyX, polyY);
end

% Set points outside polygon to NaN (clip)
xClip(~inside) = NaN;
yClip(~inside) = NaN;

end