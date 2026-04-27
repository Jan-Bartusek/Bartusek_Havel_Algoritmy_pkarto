function [xClip, yClip] = clipLineToPolygon_6(x, y, polyX, polyY)

% Clip a line to the polygon boundary by setting outside points to NaN.
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
