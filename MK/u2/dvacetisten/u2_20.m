% Main script: Visualizes icosahedron faces with gnomonic projection
clc;
clear;
close all;

R = 1;

% Geographic graticule parameters
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

% Continents
conts = {'amer.txt', 'anta.txt', 'austr.txt', 'eur.txt'};

[verticesGeo, facesIdx, facePoles, faceNames] = buildIcosahedron_20();

% Definition of 20 faces

nFaces = size(facesIdx, 1);
faces = struct('name', {}, 'uk', {}, 'vk', {}, 'ub', {}, 'vb', {});

for i = 1:nFaces
    idx = facesIdx(i,:);

    faces(i).name = faceNames{i};
    faces(i).uk = facePoles(i,1);
    faces(i).vk = facePoles(i,2);
    faces(i).ub = verticesGeo(idx,1)';
    faces(i).vb = verticesGeo(idx,2)';
end

% Display all faces

figure('Color', 'w', 'Name', 'Icosahedron - all faces');
tiledlayout(4, 5, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:nFaces
    nexttile;
    createGlobeFace_20(uv, steps, R, faces(i).uk, faces(i).vk, conts, faces(i).ub, faces(i).vb);
    title(['Face ', faces(i).name], 'FontWeight', 'bold', 'FontSize', 9);
end

% Individual faces

for i = 1:nFaces
    figure('Color', 'w', 'Name', ['Face ', faces(i).name]);
    createGlobeFace_20(uv, steps, R, faces(i).uk, faces(i).vk, conts, faces(i).ub, faces(i).vb);
    title(['Icosahedron - face ', faces(i).name], 'FontWeight', 'bold');
end
