function createGlobeFace_8(uv, steps, R, uk, vk, conts, ub, vb)
% createGlobeFace_8 draws a globe face with graticule and continents.

umin = uv(1);
umax = uv(2);
vmin = uv(3);
vmax = uv(4);

Du = steps(1);
Dv = steps(2);
du = steps(3);
dv = steps(4);

% Face boundary in projected coordinates.
[XB, YB, polyX, polyY] = boundary_8(R, uk, vk, ub, vb);

% Compute the graticule lines clipped to the face polygon.
[XM, YM, XP, YP] = graticule_8(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, polyX, polyY);

hold on;
axis equal;
box on;

% Plot meridians and parallels.
plot(XM', YM', 'k', 'LineWidth', 0.4);
plot(XP', YP', 'k', 'LineWidth', 0.4);

% Draw continent outlines.
for i = 1:length(conts)
    [XC, YC] = drawContinent_8(conts{i}, R, uk, vk, polyX, polyY);
    plot(XC, YC, 'b', 'LineWidth', 0.8);
end

% Draw the face boundary in red.
plot(XB, YB, 'r', 'LineWidth', 1.5);

xlabel('x');
ylabel('y');

% Add a margin around the face for visibility.
mx = 0.08 * (max(polyX) - min(polyX));
my = 0.08 * (max(polyY) - min(polyY));

if mx == 0
    mx = 0.1;
end
if my == 0
    my = 0.1;
end

xlim([min(polyX)-mx, max(polyX)+mx]);
ylim([min(polyY)-my, max(polyY)+my]);

end