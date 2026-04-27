function [xClip, yClip] = clipLineToPolygon_20(x, y, polyX, polyY)
% Clips line segments to remain within a polygonal region
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