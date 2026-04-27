clc;
clear;
close all;

% List of continent data files
conts = {'amer.txt', 'anta.txt', 'austr.txt', 'eur.txt'};

% 3D vertices of the octahedron (unit sphere)
A3 = geoToCart_8(0, 0);
B3 = geoToCart_8(0, 90*pi/180);
C3 = geoToCart_8(0, 180*pi/180);
D3 = geoToCart_8(0, 270*pi/180);
E3 = geoToCart_8(pi/2, 0);
F3 = geoToCart_8(-pi/2, 0);

% Assemble vertex matrix
V = [
    A3;   % 1
    B3;   % 2
    C3;   % 3
    D3;   % 4
    E3;   % 5
    F3    % 6
];

% Labels for vertices
labels = {'A','B','C','D','E','F'};

% Geographic coordinates of octahedron vertices (u,v)
A = [0, 0];
B = [0, 90*pi/180];
C = [0, 180*pi/180];
D = [0, 270*pi/180];
E = [pi/2, 0];
F = [-pi/2, 0];

% Constant latitude for face centers
u = asin(sqrt(3)/3);

% Map (u,v) for face centers (north)
I = [ u,  45*pi/180];
J = [ u, 135*pi/180];
K = [ u, 225*pi/180];
L = [ u, 315*pi/180];

% Map (u,v) for face centers (south)
M = [-u,  45*pi/180];
N = [-u, 135*pi/180];
O = [-u, 225*pi/180];
P = [-u, 315*pi/180];

% Define 8 faces with their mapping centers, boundary vertices, and indices
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

% Faces list for patch drawing
FACES = vertcat(faces.vertexIdx);

% Create figure and set view
figure('Color','w');
hold on;
axis equal;
grid on;
view(45, 25);
axis vis3d;

% Draw semi-transparent octahedron patch
patch('Vertices', V, ...
      'Faces', FACES, ...
      'FaceColor', [0.82 0.86 1.0], ...
      'EdgeColor', 'k', ...
      'FaceAlpha', 0.65, ...
      'LineWidth', 1.0);

% Draw vertex labels slightly offset from vertices
for i = 1:size(V,1)
    text(V(i,1)*1.08, V(i,2)*1.08, V(i,3)*1.08, labels{i}, ...
        'FontWeight','bold', 'FontSize',10, 'Color', 'k');
end

% Label face centers with face names
for i = 1:numel(faces)
    pts = V(faces(i).vertexIdx, :);
    c = mean(pts,1);
    text(c(1), c(2), c(3), faces(i).name, ...
        'Color','r', 'FontWeight','bold', 'FontSize', 10);
end

% Draw continents on each face
for i = 1:numel(faces)
    drawFaceContinents3D_8(faces(i), V, conts);
end

% Axis labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D osmisten');

% Add lighting
camlight headlight;
camlight right;
lighting gouraud;
