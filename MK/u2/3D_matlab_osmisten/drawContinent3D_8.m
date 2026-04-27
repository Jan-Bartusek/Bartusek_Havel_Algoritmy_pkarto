function drawContinent3D_8(file, r)
% Draw continent as a 3D curve on a sphere of radius r

% Load point list from file
points = load(file);

% Latitude (radians)
u = points(:,1)' * pi/180;
% Longitude (radians)
v = points(:,2)' * pi/180;   

% Convert to 3D Cartesian coordinates
x = r * cos(u) .* cos(v);
y = r * cos(u) .* sin(v);
z = r * sin(u);

% Split overly long jumps to avoid spurious connections
jumpThreshold = 0.25 * r;

for i = 1:length(x)-1
    d = hypot(hypot(x(i+1)-x(i), y(i+1)-y(i)), z(i+1)-z(i));
    if d > jumpThreshold
        x(i+1) = NaN;
        y(i+1) = NaN;
        z(i+1) = NaN;
    end
end

% Plot 3D curve
plot3(x, y, z, 'b', 'LineWidth', 1.4);

end