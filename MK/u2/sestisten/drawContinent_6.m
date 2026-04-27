function [XC, YC] = drawContinent_6(file, R, uk, vk, polyX, polyY)
% Load continent outline from file, project it, clip to the face, and break long jumps.

points = load(file);

u = points(:,1)' * pi/180;
v = points(:,2)' * pi/180;

[s, d] = uvTosd_6(u, v, uk, vk);

% Remove points too close to the horizon to avoid projection issues
sMin = 5 * pi/180;
valid = s > sMin;

XC = NaN(size(s));
YC = NaN(size(s));

if any(valid)
    [xv, yv] = gnom_6(R, s(valid), d(valid));
    XC(valid) = xv;
    YC(valid) = yv;
end

% Clip the continent outline to the actual triangular face boundary
[XC, YC] = clipLineToPolygon_6(XC, YC, polyX, polyY);

% Split lines at large jumps to avoid drawing invalid connection segments
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
