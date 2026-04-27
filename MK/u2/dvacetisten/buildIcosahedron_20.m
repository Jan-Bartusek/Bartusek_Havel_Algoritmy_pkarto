function [verticesGeo, facesIdx, facePoles, faceNames] = buildIcosahedron_20()
% Constructs a regular icosahedron with 20 triangular faces


% Standard regular icosahedron in 3D

phi = (1 + sqrt(5)) / 2;

V = [
    -1,  phi,  0;
     1,  phi,  0;
    -1, -phi,  0;
     1, -phi,  0;
     0, -1,  phi;
     0,  1,  phi;
     0, -1, -phi;
     0,  1, -phi;
     phi,  0, -1;
     phi,  0,  1;
    -phi,  0, -1;
    -phi,  0,  1
];

% Normalize vertices to unit sphere
for i = 1:size(V,1)
    V(i,:) = V(i,:) / norm(V(i,:));
end

% Triangular faces of the icosahedron

facesIdx = [
     1, 12,  6;
     1,  6,  2;
     1,  2,  8;
     1,  8, 11;
     1, 11, 12;
     2,  6, 10;
     6, 12,  5;
    12, 11,  3;
    11,  8,  7;
     8,  2,  9;
     4, 10,  5;
     4,  5,  3;
     4,  3,  7;
     4,  7,  9;
     4,  9, 10;
     5, 10,  6;
     3,  5, 12;
     7,  3, 11;
     9,  7,  8;
    10,  9,  2
];


% Convert vertices to [u, v] geographic coordinates

verticesGeo = zeros(size(V,1), 2);

for i = 1:size(V,1)
    [u, v] = cartToGeo_20(V(i,1), V(i,2), V(i,3));
    verticesGeo(i,:) = [u, v];
end

% Cartographic poles = normalized face centers

facePoles = zeros(size(facesIdx,1), 2);

for i = 1:size(facesIdx,1)
    ids = facesIdx(i,:);
    c = mean(V(ids,:), 1);
    c = c / norm(c);

    [uk, vk] = cartToGeo_20(c(1), c(2), c(3));
    facePoles(i,:) = [uk, vk];
end

% Face names
faceNames = cell(size(facesIdx,1), 1);
for i = 1:size(facesIdx,1)
    faceNames{i} = sprintf('F%02d', i);
end

end