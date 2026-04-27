function [XC, YC] = drawContinent_4(file, R, uk, vk, polyX, polyY)
% Loads continent data from file and projects it to gnomonic coordinates, clipping to polygon

points = load(file);

u = points(:,1)' * pi/180;
v = points(:,2)' * pi/180;

[s, d] = uvTosd_4(u, v, uk, vk);

% Cut off points close to horizon
sMin = 5 * pi/180;
valid = s > sMin;

XC = NaN(size(s));
YC = NaN(size(s));

if any(valid)
    [xv, yv] = gnom_4(R, s(valid), d(valid));
    XC(valid) = xv;
    YC(valid) = yv;
end

% Clipping to the actual face triangle
[XC, YC] = clipLineToPolygon_4(XC, YC, polyX, polyY);

% Safety split for large jumps
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