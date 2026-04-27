% Main script: Gnomonic projection of a tetrahedron with geographic grid and continents

clc;
clear;
close all;

R = 1;

% Geographic grid
Du = 10 * pi/180;
Dv = 10 * pi/180;
du = 1 * pi/180;
dv = 1 * pi/180;
steps = [Du, Dv, du, dv];

% Range
umin = -90 * pi/180;
umax =  90 * pi/180;
vmin = -180 * pi/180;
vmax =  180 * pi/180;
uv = [umin, umax, vmin, vmax];

% Continents
conts = {'amer.txt', 'anta.txt', 'austr.txt', 'eur.txt'};

% GEOMETRY

u = asin(1/3);

A = [-u, 0];
B = [-u, 120*pi/180];
C = [-u, 240*pi/180];
D = [ pi/2, 0];

K = [ u,  60*pi/180];
L = [ u, 180*pi/180];
M = [ u, 300*pi/180];
N = [-pi/2, 0];

faces(1).name = 'K';
faces(1).uk = K(1); faces(1).vk = K(2);
faces(1).ub = [A(1), B(1), D(1)];
faces(1).vb = [A(2), B(2), D(2)];

faces(2).name = 'L';
faces(2).uk = L(1); faces(2).vk = L(2);
faces(2).ub = [B(1), C(1), D(1)];
faces(2).vb = [B(2), C(2), D(2)];

faces(3).name = 'M';
faces(3).uk = M(1); faces(3).vk = M(2);
faces(3).ub = [C(1), A(1), D(1)];
faces(3).vb = [C(2), A(2), D(2)];

faces(4).name = 'N';
faces(4).uk = N(1); faces(4).vk = N(2);
faces(4).ub = [A(1), C(1), B(1)];
faces(4).vb = [A(2), C(2), B(2)];

% Rendering all faces

figure('Color','w');
tiledlayout(2,2);

for i = 1:4
    nexttile;
    createGlobeFace_4(uv, steps, R, faces(i).uk, faces(i).vk, conts, faces(i).ub, faces(i).vb);
    title(['Face ', faces(i).name]);
end
