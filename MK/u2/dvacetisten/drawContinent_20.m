function [XC, YC] = drawContinent_20(file, R, uk, vk, polyX, polyY)
% Loads and projects continent coordinates onto gnomonic projection
points = load(file);

u = points(:,1)' * pi/180;
v = points(:,2)' * pi/180;

[s, d] = uvTosd_20(u, v, uk, vk);

sMin = 5 * pi/180;
valid = s > sMin;

XC = NaN(size(s));
YC = NaN(size(s));

if any(valid)
    [xv, yv] = gnom_20(R, s(valid), d(valid));
    XC(valid) = xv;
    YC(valid) = yv;
end

[XC, YC] = clipLineToPolygon_20(XC, YC, polyX, polyY);

dx = max(polyX) - min(polyX);
dy = max(polyY) - min(polyY);
jumpThreshold = 0.75 * max(dx, dy);

for i = 1:length(XC)-1
    if ~isnan(XC(i)) && ~isnan(XC(i+1)) && ~isnan(YC(i)) && ~isnan(YC(i+1))
        if hypot(XC(i+1)-XC(i), YC(i+1)-YC(i)) > jumpThreshold
            XC(i+1) = NaN;
            YC(i+1) = NaN;
        end
    end
end

end