% Draws a complete tetrahedron face with boundary, graticule, and continents
function createGlobeFace_4(uv, steps, R, uk, vk, conts, ub, vb)

umin = uv(1);
umax = uv(2);
vmin = uv(3);
vmax = uv(4);

Du = steps(1);
Dv = steps(2);
du = steps(3);
dv = steps(4);

% Face boundary
[XB, YB, polyX, polyY] = boundary_4(R, uk, vk, ub, vb);

% Grid
[XM, YM, XP, YP] = graticule_4(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, polyX, polyY);

hold on;
axis equal;
box on;

% Meridians and parallels
plot(XM', YM', 'k', 'LineWidth', 0.4);
plot(XP', YP', 'k', 'LineWidth', 0.4);

% Continents
for i = 1:length(conts)
    [XC, YC] = drawContinent_4(conts{i}, R, uk, vk, polyX, polyY);
    plot(XC, YC, 'b', 'LineWidth', 0.8);
end

% Face boundary
plot(XB, YB, 'r', 'LineWidth', 1.5);

xlabel('x');
ylabel('y');

% Margin around face
mx = 0.08 * max(polyX) - 0.08 * min(polyX);
my = 0.08 * max(polyY) - 0.08 * min(polyY);

if mx == 0
    mx = 0.1;
end
if my == 0
    my = 0.1;
end

xlim([min(polyX)-mx, max(polyX)+mx]);
ylim([min(polyY)-my, max(polyY)+my]);

end