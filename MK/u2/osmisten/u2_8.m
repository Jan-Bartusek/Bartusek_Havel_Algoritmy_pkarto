clc;
clear;
close all;

R = 1;

% Geographic grid settings
Du = 10 * pi/180;
Dv = 10 * pi/180;
du = 1 * pi/180;
dv = 1 * pi/180;
steps = [Du, Dv, du, dv];

% Global range for grid generation
umin = -90 * pi/180;
umax =  90 * pi/180;
vmin = -180 * pi/180;
vmax =  180 * pi/180;
uv = [umin, umax, vmin, vmax];

% Continent data files
conts = {'amer.txt', 'anta.txt', 'austr.txt', 'eur.txt'};

% Geometry parameters

u = asin(sqrt(3)/3);   % approximately 35.2644°

% Corner vertices of the octahedron faces
A = [0, 0];
B = [0,  90*pi/180];
C = [0, 180*pi/180];
D = [0, 270*pi/180];
E = [ pi/2, 0];
F = [-pi/2, 0];

% Face centers in geographic coordinates
I = [ u,  45*pi/180];
J = [ u, 135*pi/180];
K = [ u, 225*pi/180];
L = [ u, 315*pi/180];

M = [-u,  45*pi/180];
N = [-u, 135*pi/180];
O = [-u, 225*pi/180];
P = [-u, 315*pi/180];

% Face definitions:
% Top 4 triangles around the north pole E
% Bottom 4 triangles around the south pole F

faces(1).name = 'I';
faces(1).uk = I(1); faces(1).vk = I(2);
faces(1).ub = [A(1), B(1), E(1)];
faces(1).vb = [A(2), B(2), E(2)];

faces(2).name = 'J';
faces(2).uk = J(1); faces(2).vk = J(2);
faces(2).ub = [B(1), C(1), E(1)];
faces(2).vb = [B(2), C(2), E(2)];

faces(3).name = 'K';
faces(3).uk = K(1); faces(3).vk = K(2);
faces(3).ub = [C(1), D(1), E(1)];
faces(3).vb = [C(2), D(2), E(2)];

faces(4).name = 'L';
faces(4).uk = L(1); faces(4).vk = L(2);
faces(4).ub = [D(1), A(1), E(1)];
faces(4).vb = [D(2), A(2), E(2)];

faces(5).name = 'M';
faces(5).uk = M(1); faces(5).vk = M(2);
faces(5).ub = [B(1), A(1), F(1)];
faces(5).vb = [B(2), A(2), F(2)];

faces(6).name = 'N';
faces(6).uk = N(1); faces(6).vk = N(2);
faces(6).ub = [C(1), B(1), F(1)];
faces(6).vb = [C(2), B(2), F(2)];

faces(7).name = 'O';
faces(7).uk = O(1); faces(7).vk = O(2);
faces(7).ub = [D(1), C(1), F(1)];
faces(7).vb = [D(2), C(2), F(2)];

faces(8).name = 'P';
faces(8).uk = P(1); faces(8).vk = P(2);
faces(8).ub = [A(1), D(1), F(1)];
faces(8).vb = [A(2), D(2), F(2)];

% Draw all faces in a tiled figure
figure('Color', 'w', 'Name', 'Osmisten - all faces');
tiledlayout(2, 4, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:8
    nexttile;
    createGlobeFace_8(uv, steps, R, faces(i).uk, faces(i).vk, conts, faces(i).ub, faces(i).vb);
    title(['Face ', faces(i).name], 'FontWeight', 'bold');
end

% Draw each face in a separate figure
for i = 1:8
    figure('Color', 'w', 'Name', ['Face ', faces(i).name]);
    createGlobeFace_8(uv, steps, R, faces(i).uk, faces(i).vk, conts, faces(i).ub, faces(i).vb);
    title(['Osmisten - face ', faces(i).name], 'FontWeight', 'bold');
end
