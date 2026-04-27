function [xClip, yClip] = clipLineToPolygon_4(x, y, polyX, polyY)
% Clips line coordinates to a polygon boundary, setting external points to NaN

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