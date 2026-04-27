clc;
clear;
close all;
% EXPORT OSMISTEN + GRID + CONTINENTS TO OBJ

conts = {'amer.txt', 'anta.txt', 'austr.txt', 'eur.txt'};

% grid parameters
Du = 10 * pi/180;
Dv = 10 * pi/180;
du = 1 * pi/180;
dv = 1 * pi/180;

umin = -90 * pi/180;
umax =  90 * pi/180;
vmin = -180 * pi/180;
vmax =  180 * pi/180;


% 3D VERTICES OF THE OCTAHEDRON
A3 = geoToCart_8(0, 0);
B3 = geoToCart_8(0, 90*pi/180);
C3 = geoToCart_8(0, 180*pi/180);
D3 = geoToCart_8(0, 270*pi/180);
E3 = geoToCart_8(pi/2, 0);
F3 = geoToCart_8(-pi/2, 0);

V = [
    A3;
    B3;
    C3;
    D3;
    E3;
    F3
];

% geographic vertices
A = [0, 0];
B = [0, 90*pi/180];
C = [0, 180*pi/180];
D = [0, 270*pi/180];
E = [pi/2, 0];
F = [-pi/2, 0];

u = asin(sqrt(3)/3);

I = [ u,  45*pi/180];
J = [ u, 135*pi/180];
K = [ u, 225*pi/180];
L = [ u, 315*pi/180];

M = [-u,  45*pi/180];
N = [-u, 135*pi/180];
O = [-u, 225*pi/180];
P = [-u, 315*pi/180];

faces(1).name = 'I';
faces(1).uk = I(1); faces(1).vk = I(2);
faces(1).ub = [A(1), B(1), E(1)];
faces(1).vb = [A(2), B(2), E(2)];
faces(1).vertexIdx = [1 2 5];

faces(2).name = 'J';
faces(2).uk = J(1); faces(2).vk = J(2);
faces(2).ub = [B(1), C(1), E(1)];
faces(2).vb = [B(2), C(2), E(2)];
faces(2).vertexIdx = [2 3 5];

faces(3).name = 'K';
faces(3).uk = K(1); faces(3).vk = K(2);
faces(3).ub = [C(1), D(1), E(1)];
faces(3).vb = [C(2), D(2), E(2)];
faces(3).vertexIdx = [3 4 5];

faces(4).name = 'L';
faces(4).uk = L(1); faces(4).vk = L(2);
faces(4).ub = [D(1), A(1), E(1)];
faces(4).vb = [D(2), A(2), E(2)];
faces(4).vertexIdx = [4 1 5];

faces(5).name = 'M';
faces(5).uk = M(1); faces(5).vk = M(2);
faces(5).ub = [B(1), A(1), F(1)];
faces(5).vb = [B(2), A(2), F(2)];
faces(5).vertexIdx = [2 1 6];

faces(6).name = 'N';
faces(6).uk = N(1); faces(6).vk = N(2);
faces(6).ub = [C(1), B(1), F(1)];
faces(6).vb = [C(2), B(2), F(2)];
faces(6).vertexIdx = [3 2 6];

faces(7).name = 'O';
faces(7).uk = O(1); faces(7).vk = O(2);
faces(7).ub = [D(1), C(1), F(1)];
faces(7).vb = [D(2), C(2), F(2)];
faces(7).vertexIdx = [4 3 6];

faces(8).name = 'P';
faces(8).uk = P(1); faces(8).vk = P(2);
faces(8).ub = [A(1), D(1), F(1)];
faces(8).vb = [A(2), D(2), F(2)];
faces(8).vertexIdx = [1 4 6];

FACES = vertcat(faces.vertexIdx);


% Collect 3D lines
allLines = {};

for i = 1:numel(faces)
    lineSet = collectFaceLines3D_8(faces(i), V, conts, ...
        umin, umax, vmin, vmax, Du, Dv, du, dv);

    for j = 1:numel(lineSet)
        allLines{end+1} = lineSet{j};
    end
end

% Scaling for export/printing

scale = 50;
V_obj = V * scale;

for i = 1:numel(allLines)
    allLines{i} = allLines{i} * scale;
end


% Export
exportOBJ_8('osmisten_lines_8.obj', V_obj, FACES, allLines);

fprintf('Done. OBJ exported to osmisten_lines_8.obj\n');
