% Main script for plotting six projected globe faces with continents.
clc;
clear;
close all;

% Radius of the sphere used for the projection plotting
R = 1;

% Geographic grid spacing for meridians and parallels
Du = 10 * pi/180;
Dv = 10 * pi/180;
du = 1 * pi/180;
dv = 1 * pi/180;
steps = [Du, Dv, du, dv];

% Range for generating the grid in geographic coordinates
umin = -90 * pi/180;
umax =  90 * pi/180;
vmin = -180 * pi/180;
vmax =  180 * pi/180;
uv = [umin, umax, vmin, vmax];

% Continent outline files to draw on each face
conts = {'amer.txt', 'anta.txt', 'austr.txt', 'eur.txt'};

% Geometry of the cube-octahedron face orientation
u = atan(1 / sqrt(2));   % approx. 35.2644°

% Face corner vertices in geographic coordinates
A = [-u,   0*pi/180];
B = [-u,  90*pi/180];
C = [-u, 180*pi/180];
D = [-u, 270*pi/180];

E = [ u,   0*pi/180];
F = [ u,  90*pi/180];
G = [ u, 180*pi/180];
H = [ u, 270*pi/180];

% Cartographic face center coordinates for the six faces
K = [0,  45*pi/180];
L = [0, 135*pi/180];
M = [0, 225*pi/180];
N = [0, 315*pi/180];
S = [ pi/2, 0];
J = [-pi/2, 0];

faces(1).name = 'K';
faces(1).uk = K(1); faces(1).vk = K(2);
faces(1).ub = [A(1), B(1), F(1), E(1)];
faces(1).vb = [A(2), B(2), F(2), E(2)];

faces(2).name = 'L';
faces(2).uk = L(1); faces(2).vk = L(2);
faces(2).ub = [B(1), C(1), G(1), F(1)];
faces(2).vb = [B(2), C(2), G(2), F(2)];

faces(3).name = 'M';
faces(3).uk = M(1); faces(3).vk = M(2);
faces(3).ub = [C(1), D(1), H(1), G(1)];
faces(3).vb = [C(2), D(2), H(2), G(2)];

faces(4).name = 'N';
faces(4).uk = N(1); faces(4).vk = N(2);
faces(4).ub = [D(1), A(1), E(1), H(1)];
faces(4).vb = [D(2), A(2), E(2), H(2)];

faces(5).name = 'S';
faces(5).uk = S(1); faces(5).vk = S(2);
faces(5).ub = [E(1), F(1), G(1), H(1)];
faces(5).vb = [E(2), F(2), G(2), H(2)];

faces(6).name = 'J';
faces(6).uk = J(1); faces(6).vk = J(2);
faces(6).ub = [A(1), D(1), C(1), B(1)];
faces(6).vb = [A(2), D(2), C(2), B(2)];

% Plot all six faces in a single tiled figure

figure('Color', 'w', 'Name', 'Sestisten - vsechny steny');
tiledlayout(2, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:6
    nexttile;
    createGlobeFace_6(uv, steps, R, faces(i).uk, faces(i).vk, conts, faces(i).ub, faces(i).vb);
    title(['Stena ', faces(i).name], 'FontWeight', 'bold');
end

% Plot each face separately in its own figure

for i = 1:6
    figure('Color', 'w', 'Name', ['Stena ', faces(i).name]);
    createGlobeFace_6(uv, steps, R, faces(i).uk, faces(i).vk, conts, faces(i).ub, faces(i).vb);
    title(['Sestisten - stena ', faces(i).name], 'FontWeight', 'bold');
end
